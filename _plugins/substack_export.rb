require 'base64'
require 'cgi'
require 'digest'
require 'fileutils'
require 'json'
require 'nokogiri'
require 'open3'
require 'time'
require 'uri'

module SubstackExport
  NAMESPACES = {
    'content' => 'http://purl.org/rss/1.0/modules/content/',
    'export' => 'https://j-abed.github.io/substack-export'
  }.freeze

  class Exporter
    def initialize(destination:, site_url:)
      @destination = File.expand_path(destination)
      @site_url = URI.parse(site_url)
      @assets = []
      @charts = []
      @warnings = []
    end

    def absolute_url(value, canonical)
      return value if value.to_s.empty?
      url = URI.join(canonical, value.to_s.strip.gsub(' ', '%20'))
      raise "Unsupported URL: #{value}" unless %w[http https mailto tel].include?(url.scheme)
      url.to_s
    end

    def local_file(url)
      uri = URI.parse(url)
      return unless uri.host == @site_url.host && uri.port == @site_url.port
      path = File.expand_path(URI::DEFAULT_PARSER.unescape(uri.path).delete_prefix('/'), @destination)
      raise "Asset escapes build directory: #{url}" unless path.start_with?("#{@destination}/")
      path
    end

    def write_asset(bytes, extension)
      relative = "assets/substack/#{Digest::SHA256.hexdigest(bytes)}.#{extension}"
      path = File.join(@destination, relative)
      FileUtils.mkdir_p(File.dirname(path))
      File.binwrite(path, bytes) unless File.file?(path)
      url = URI.join(@site_url.to_s.end_with?('/') ? @site_url.to_s : "#{@site_url}/", relative).to_s
      @assets << url unless @assets.include?(url)
      url
    end

    def rasterize(svg)
      document = Nokogiri::XML(svg) { |config| config.strict.nonet }
      root = document.root
      raise 'Expected SVG image' unless root && root.name == 'svg'
      document.css('script, foreignObject').remove
      document.traverse do |node|
        next unless node.element?
        node.attribute_nodes.each do |attribute|
          node.remove_attribute(attribute.name) if attribute.name.start_with?('on')
        end
        %w[href xlink:href].each do |attribute|
          value = node[attribute]
          raise 'SVG external resources need a self-contained PNG replacement' if value && !value.start_with?('#', 'data:image/')
        end
      end
      width = root['viewBox'].to_s.split(/[ ,]+/)[2].to_f
      width = root['width'].to_f if width <= 0
      pixels = [[(width * 3).ceil, 1600].max, 8192].min
      bytes, error, result = Open3.capture3('rsvg-convert', '--format=png', '--width', pixels.to_s,
                                           '--background-color', '#ffffff', stdin_data: document.to_xml, binmode: true)
      raise "SVG conversion failed: #{error}" unless result.success? && bytes.start_with?("\x89PNG".b)
      url = write_asset(bytes, 'png')
      @charts << url unless @charts.include?(url)
      url
    rescue Errno::ENOENT
      raise 'Install librsvg (rsvg-convert) before exporting selected SVG charts'
    end

    def image_node(fragment, url, alt)
      image = Nokogiri::XML::Node.new('img', fragment.document)
      image['src'] = url
      image['alt'] = alt.to_s
      image['style'] = 'max-width:100%;height:auto'
      image
    end

    def prepare_html(html, canonical:, static_image: nil)
      fragment = Nokogiri::HTML5.fragment(html)
      fragment.css('script, style, link, .midterms-detail, form, button, input, select, textarea').remove
      fragment.css('details').each do |details|
        details.name = 'section'
        details.at_css('summary')&.name = 'h3'
        details.remove_attribute('open')
      end
      fragment.css('svg').each do |svg|
        alt = [svg.at_css('title')&.text, svg.at_css('desc')&.text].compact.join('. ')
        url = rasterize(svg.to_html)
        link = Nokogiri::XML::Node.new('a', fragment.document)
        link['href'] = url
        link.add_child(image_node(fragment, url, alt))
        svg.replace(link)
      end
      fragment.css('figure').each { |figure| figure['style'] = 'margin:1.5em 0' }
      fragment.css('iframe, object, embed, canvas, video, audio').each do |interactive|
        preview = interactive['data-substack-image'] || interactive['poster'] || static_image
        raise "Missing static preview in #{canonical}: configure substack.static_images" unless preview
        block = Nokogiri::XML::Node.new('p', fragment.document)
        block.add_child(image_node(fragment, absolute_url(preview, canonical), interactive['title'] || 'Static preview')) if preview
        link = Nokogiri::XML::Node.new('a', fragment.document)
        link['href'] = absolute_url(interactive['src'] || interactive['data'] || canonical, canonical)
        link.content = "Open interactive content on the original site#{interactive['title'] ? ": #{interactive['title']}" : ''}"
        block.add_child(link)
        interactive.replace(block)
        @warnings << "#{canonical}: interactive component replaced with static preview and original link; review the preview"
      end
      fragment.css('table').each do |table|
        if table.css('thead tr').length > 1 || table.css('[rowspan], [colspan]').any? { |cell| cell['rowspan'].to_i > 1 || cell['colspan'].to_i > 1 }
          raise "Complex table in #{canonical}: provide a simple static table before export"
        end
        replacement = Nokogiri::XML::Node.new('div', fragment.document)
        if (caption = table.at_css('caption'))
          heading = Nokogiri::XML::Node.new('p', fragment.document)
          heading.inner_html = caption.inner_html
          replacement.add_child(heading)
        end
        rows = table.css('tr')
        header = table.at_css('thead tr:last-child') || rows.find { |row| row.element_children.all? { |cell| cell.name == 'th' } }
        labels = header ? header.css('th, td').map(&:text) : []
        rows.each do |row|
          next if row == header || row.ancestors.any? { |ancestor| ancestor.name == 'thead' }
          list = Nokogiri::XML::Node.new('p', fragment.document)
          list['class'] = 'substack-table-row'
          row.css('th, td').each_with_index do |cell, index|
            term = Nokogiri::XML::Node.new('strong', fragment.document)
            term.content = "#{labels[index] || "Column #{index + 1}"}: "
            value = Nokogiri::XML::Node.new('span', fragment.document)
            value['class'] = 'substack-table-value'
            value.inner_html = cell.inner_html
            list.add_child(term)
            list.add_child(value)
            list.add_child(Nokogiri::XML::Node.new('br', fragment.document))
          end
          replacement.add_child(list)
        end
        table.replace(replacement)
      end
      fragment.css('picture source').remove
      fragment.css('img').each do |image|
        source = image['src']
        raise "Image has no src in #{canonical}" if source.to_s.empty?
        if source.start_with?('data:image/')
          mime, encoded = source.split(';base64,', 2)
          raise 'Only base64 PNG/JPEG/GIF/WebP/SVG images are supported' unless encoded
          bytes = Base64.strict_decode64(encoded)
          extension = { 'data:image/png' => 'png', 'data:image/jpeg' => 'jpg', 'data:image/gif' => 'gif', 'data:image/webp' => 'webp' }[mime]
          image['src'] = mime == 'data:image/svg+xml' ? rasterize(bytes) : write_asset(bytes, extension || (raise 'Unsupported embedded image'))
        else
          image['src'] = absolute_url(source, canonical)
          raise 'Images must use HTTP(S)' unless %w[http https].include?(URI.parse(image['src']).scheme)
          if URI.parse(image['src']).path.downcase.end_with?('.svg')
            path = local_file(image['src'])
            raise "Provide a local PNG for external SVG: #{image['src']}" unless path && File.file?(path)
            image['src'] = rasterize(File.read(path))
          end
        end
        image['style'] = 'max-width:100%;height:auto'
        %w[width height srcset sizes loading].each { |attribute| image.remove_attribute(attribute) }
        path = local_file(image['src'])
        raise "Missing exported image: #{image['src']}" if path && !File.file?(path)
      end
      fragment.css('a[href]').each { |link| link['href'] = absolute_url(link['href'], canonical) }
      fragment.traverse do |node|
        next unless node.element?
        node.attribute_nodes.each do |attribute|
          node.remove_attribute(attribute.name) if attribute.name.start_with?('on', 'data-')
        end
      end
      attribution = Nokogiri::XML::Node.new('p', fragment.document)
      link = Nokogiri::XML::Node.new('a', fragment.document)
      link['href'] = canonical
      link.content = 'Read the original article on the canonical GitHub Pages site.'
      attribution.add_child(link)
      fragment.add_child(attribution)
      fragment.to_html
    end

    def run
      path = File.join(@destination, 'substack-feed.xml')
      return unless File.file?(path)
      feed = Nokogiri::XML(File.read(path)) { |config| config.strict.nonet }
      selected = []
      feed.xpath('/rss/channel/item').each do |item|
        canonical = item.at_xpath('link').text
        content = item.at_xpath('content:encoded', NAMESPACES)
        static_image = item.at_xpath('export:static-image', NAMESPACES)
        content.content = prepare_html(content.text, canonical: canonical, static_image: static_image&.text)
        static_image&.remove
        selected << { title: item.at_xpath('title').text, url: canonical, guid: item.at_xpath('guid').text,
                      published: Time.rfc2822(item.at_xpath('pubDate').text).iso8601,
                      content_sha256: Digest::SHA256.hexdigest(content.text) }
      end
      feed.at_xpath('/rss/channel/export:status', NAMESPACES).content = 'ready'
      File.write(path, feed.to_xml)
      folder = File.join(@destination, 'substack-export')
      FileUtils.mkdir_p(folder)
      selected.each_with_index do |post, index|
        filename = "#{Digest::SHA256.hexdigest(post[:guid])}.html"
        post[:preview] = URI.join(@site_url.to_s, "/substack-export/#{filename}").to_s
        body = feed.xpath('/rss/channel/item')[index].at_xpath('content:encoded', NAMESPACES).text
        preview_body = Nokogiri::HTML5.fragment(body)
        preview_body.css('img[src], a[href]').each do |node|
          attribute = node.name == 'img' ? 'src' : 'href'
          uri = URI.parse(node[attribute])
          if local_file(node[attribute]) && (node.name == 'img' || uri.path.start_with?('/assets/substack/'))
            node[attribute] = uri.request_uri
          end
        end
        body = preview_body.to_html
        File.write(File.join(folder, filename), "<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><title>#{CGI.escapeHTML(post[:title])}</title><link rel=\"canonical\" href=\"#{CGI.escapeHTML(post[:url])}\"><meta name=\"robots\" content=\"noindex\"><style>body{max-width:760px;margin:2rem auto;padding:0 1rem;line-height:1.6}img{max-width:100%;height:auto}pre{overflow:auto}dt{font-weight:bold}dd{margin:0 0 1rem;overflow-wrap:anywhere}</style></head><body><h1>#{CGI.escapeHTML(post[:title])}</h1><p>#{CGI.escapeHTML(post[:published])}</p>#{body}</body></html>")
      end
      manifest = { feed: URI.join(@site_url.to_s, '/substack-feed.xml').to_s, posts: selected, generated_images: @assets, rasterized_charts: @charts, warnings: @warnings }
      File.write(File.join(folder, 'manifest.json'), JSON.pretty_generate(manifest))
      entries = selected.map { |post| "<li>#{CGI.escapeHTML(post[:published])} <a href=\"#{CGI.escapeHTML(post[:preview])}\">#{CGI.escapeHTML(post[:title])}</a> <a href=\"#{CGI.escapeHTML(post[:url])}\">Original</a></li>" }.join
      File.write(File.join(folder, 'index.html'), "<!doctype html><html lang=\"en\"><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><meta name=\"robots\" content=\"noindex\"><title>Selected Substack exports</title><h1>Selected Substack exports</h1><p>#{selected.length} posts. Review dates and full-text previews before importing. Nothing is sent to Substack.</p><ul>#{entries}</ul><a href=\"manifest.json\">Validation manifest</a></html>")
    end
  end
end

if defined?(Jekyll::Hooks)
  Jekyll::Hooks.register :site, :post_read do |site|
    site.config['substack_export_enabled'] = true
  end
  Jekyll::Hooks.register :site, :post_write do |site|
    SubstackExport::Exporter.new(destination: site.dest, site_url: site.config.fetch('url')).run
  end
end