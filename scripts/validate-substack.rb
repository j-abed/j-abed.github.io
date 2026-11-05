require 'jekyll'
require_relative '../_plugins/substack_export'

destination = File.expand_path(ARGV.fetch(0, '_site'))
feed = Nokogiri::XML(File.read(File.join(destination, 'substack-feed.xml'))) { |parser| parser.strict.nonet }
namespaces = SubstackExport::NAMESPACES
raise 'Export disabled: use scripts/build-substack.rb, not the legacy safe-mode build' unless feed.at_xpath('//export:status', namespaces)&.text == 'ready'
manifest = JSON.parse(File.read(File.join(destination, 'substack-export', 'manifest.json')))
configuration = Jekyll.configuration('source' => File.expand_path('..', __dir__), 'destination' => destination,
  'future' => false, 'show_drafts' => false, 'unpublished' => false, 'quiet' => true)
site = Jekyll::Site.new(configuration)
site.read
base = site.config.fetch('url')
exporter = SubstackExport::Exporter.new(destination: destination, site_url: base)
selected = site.posts.docs.select do |post|
  post.data['substack'] == true && post.data['published'] != false && post.data['draft'] != true &&
    post.date <= site.time && !post.path.include?('_drafts/')
end
expected = selected.to_h { |post| [URI.join("#{base}/", post.url).to_s, post] }
items = feed.xpath('/rss/channel/item')
actual = items.map { |item| item.at_xpath('guid').text }
raise 'Duplicate article identifiers' unless actual.uniq.length == actual.length
raise 'Selected archive differs from source posts' unless actual.sort == expected.keys.sort
raise 'Manifest differs from RSS selection' unless manifest.fetch('posts').map { |post| post.fetch('guid') } == actual

normalize = ->(text) { text.gsub(/\s+/, ' ').strip }
items.each_with_index do |item, index|
  canonical = item.at_xpath('link').text
  post = expected.fetch(canonical)
  raise "Changed original publication date: #{canonical}" unless Time.rfc2822(item.at_xpath('pubDate').text) == post.date
  raise "Changed original title: #{canonical}" unless item.at_xpath('title').text == post.data['title']
  html = item.at_xpath('content:encoded', namespaces).text
  output = Nokogiri::HTML5.fragment(html)
  raise "Truncated content: #{canonical}" if html.strip.empty?
  raise "Unsupported dynamic content: #{canonical}" unless output.css('svg, script, style, link, iframe, canvas, object, embed, details, table, form, button, input, video, audio').empty?
  raise "Content fingerprint differs: #{canonical}" unless Digest::SHA256.hexdigest(html) == manifest['posts'][index]['content_sha256']
  path = exporter.local_file(canonical)
  original_path = [path, "#{path}.html", File.join(path, 'index.html')].find { |candidate| File.file?(candidate) }
  raise "Missing canonical article: #{canonical}" unless original_path
  original = Nokogiri::HTML5(File.read(original_path)).at_css('.post')
  raise "Missing article body: #{canonical}" unless original
  original.css('script, style, link, .post-title, .post-date, .midterms-detail, form, button, input, select, textarea').remove
  exported_text = normalize.call(output.text)
  original.css('p, h2, h3, h4, h5, h6, li, pre, blockquote, figcaption, summary').each do |block|
    next if block.ancestors.any? { |ancestor| %w[svg table].include?(ancestor.name) }
    text = normalize.call(block.text)
    raise "Editorial block lost: #{canonical}: #{text[0,100]}" unless text.empty? || exported_text.include?(text)
  end
  original_rows = original.css('table tr').reject do |row|
    row.ancestors.any? { |ancestor| ancestor.name == 'thead' } || row.element_children.all? { |cell| cell.name == 'th' }
  end.map { |row| row.css('td, th').map { |cell| normalize.call(cell.text) } }
  exported_rows = output.css('.substack-table-row').map { |row| row.css('.substack-table-value').map { |cell| normalize.call(cell.text) } }
  raise "Table cells changed: #{canonical}" unless original_rows == exported_rows
  original.css('a[href]').each do |link|
    target = exporter.absolute_url(link['href'], canonical)
    raise "Citation or link lost: #{canonical}: #{target}" unless output.css('a[href]').any? { |exported| exported['href'] == target }
  end
  output.css('a[href], img[src]').each do |node|
    url = node['href'] || node['src']
    raise "Relative URL: #{canonical}: #{url}" unless URI.parse(url).absolute?
    local = exporter.local_file(url)
    if local
      candidates = [local, "#{local}.html", File.join(local, 'index.html')]
      raise "Missing link/asset: #{url}" unless candidates.any? { |candidate| File.file?(candidate) }
      fragment = URI.parse(url).fragment
      if fragment && node.name == 'a' && (target = candidates.find { |candidate| File.file?(candidate) && candidate.end_with?('.html') })
        document = Nokogiri::HTML5(File.read(target))
        raise "Missing original anchor: #{url}" unless document.css('[id]').any? { |element| element['id'] == URI::DEFAULT_PARSER.unescape(fragment) }
      end
    end
  end
  expected_images = original.css('img, svg').length
  raise "Charts or images lost: #{canonical}" unless output.css('img').length >= expected_images
  raise "Canonical attribution missing: #{canonical}" unless output.css('a').last['href'] == canonical
  puts "PASS: #{item.at_xpath('pubDate').text} | #{item.at_xpath('title').text} | #{output.css('img').length} images, #{original_rows.length} table rows"
end

manifest.fetch('rasterized_charts').each do |url|
  bytes = File.binread(exporter.local_file(url))
  raise "Not a PNG: #{url}" unless bytes.start_with?("\x89PNG".b)
  width, height = bytes.byteslice(16, 8).unpack('NN')
  raise "Low-resolution image: #{url}" unless width >= 1600 && height > 0
end
manifest.fetch('warnings').each { |warning| warn "REVIEW: #{warning}" }
puts "PASS: #{items.length} selected posts; #{manifest['rasterized_charts'].length} high-resolution PNGs; complete narrative, citations, original dates, and table values."