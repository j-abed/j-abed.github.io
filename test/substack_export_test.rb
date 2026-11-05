require 'minitest/autorun'
require 'tmpdir'
require 'jekyll'
require_relative '../_plugins/substack_export'

class SubstackExportTest < Minitest::Test
  def setup
    @destination = Dir.mktmpdir('substack-test-')
    @exporter = SubstackExport::Exporter.new(destination: @destination, site_url: 'https://example.com')
    @canonical = 'https://example.com/2025/old-post/'
  end

  def teardown
    FileUtils.remove_entry(@destination)
  end

  def test_links_tables_and_appendix_keep_content
    html = '<h2>Research &amp; results</h2><details><summary>Appendix</summary><p>Full detail.</p></details><table><thead><tr><th>Year</th><th>Value</th></tr></thead><tr><td>2024</td><td><strong>42</strong></td></tr></table><a href="/sources/report.pdf">Source</a><script>alert(1)</script>'
    output = Nokogiri::HTML5.fragment(@exporter.prepare_html(html, canonical: @canonical))
    assert_empty output.css('script, table, details')
    assert_equal 'Appendix', output.at_css('section h3').text
    assert_includes output.text, 'Full detail.'
    assert_equal '42', output.at_css('.substack-table-value strong').text
    assert_equal 'https://example.com/sources/report.pdf', output.at_css('a')['href']
    assert_equal @canonical, output.css('a').last['href']
  end

  def test_inline_svg_is_high_resolution_png_with_stable_url
    html = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 760 470"><title>Example chart</title><rect width="760" height="470" fill="white"/><circle cx="100" cy="100" r="50" fill="red"/></svg>'
    first = Nokogiri::HTML5.fragment(@exporter.prepare_html(html, canonical: @canonical)).at_css('img')
    second = Nokogiri::HTML5.fragment(@exporter.prepare_html(html, canonical: @canonical)).at_css('img')
    assert_equal first['src'], second['src']
    assert_equal 'Example chart', first['alt']
    bytes = File.binread(@exporter.local_file(first['src']))
    assert_equal "\x89PNG".b, bytes.byteslice(0, 4)
    assert_equal [2280, 1410], bytes.byteslice(16, 8).unpack('NN')
  end

  def test_interactive_embed_gets_static_preview_and_original_link
    File.binwrite(File.join(@destination, 'preview.png'), 'fixture')
    html = '<iframe src="/tool.html" title="Model"></iframe>'
    output = Nokogiri::HTML5.fragment(@exporter.prepare_html(html, canonical: @canonical, static_image: '/preview.png'))
    assert_empty output.css('iframe')
    assert_equal 'https://example.com/preview.png', output.at_css('img')['src']
    assert_equal 'https://example.com/tool.html', output.at_css('a')['href']
  end

  def test_unsafe_urls_and_missing_images_fail
    assert_raises(RuntimeError) { @exporter.prepare_html('<a href="javascript:alert(1)">Unsafe</a>', canonical: @canonical) }
    assert_raises(RuntimeError) { @exporter.prepare_html('<img src="/missing.png">', canonical: @canonical) }
    assert_raises(RuntimeError) { @exporter.local_file('https://example.com/%2e%2e/outside.png') }
    assert_raises(RuntimeError) { @exporter.prepare_html('<iframe src="/tool.html"></iframe>', canonical: @canonical) }
  end

  def test_feed_is_unlimited_full_text_and_excludes_every_unpublished_path
    source = File.join(@destination, 'source')
    FileUtils.mkdir_p(File.join(source, '_posts'))
    FileUtils.mkdir_p(File.join(source, '_drafts'))
    FileUtils.cp(File.expand_path('../substack-feed.xml', __dir__), source)
    26.times do |index|
      File.write(File.join(source, '_posts', "2025-01-#{format('%02d', index + 1)}-post.md"), "---\ntitle: Post #{index}\ndate: 2025-01-#{format('%02d', index + 1)} 09:30:00 -0500\nsubstack: true\n---\nOpening.\n\nSecond full-text paragraph & detail.\n")
    end
    { '2025-02-01-unpublished.md' => "substack: true\npublished: false",
      '2025-02-02-draft.md' => "substack: true\ndraft: true",
      '2025-02-03-unselected.md' => 'substack: false',
      '2025-02-04-string.md' => 'substack: "true"',
      '2099-02-01-future.md' => 'substack: true' }.each do |filename, flags|
      File.write(File.join(source, '_posts', filename), "---\ntitle: Forbidden\n#{flags}\n---\nExcluded.\n")
    end
    File.write(File.join(source, '_drafts', 'draft.md'), "---\ntitle: Forbidden\ndate: 2025-01-01\nsubstack: true\n---\nExcluded.\n")
    configuration = Jekyll.configuration('source' => source, 'destination' => File.join(@destination, 'build'),
      'url' => 'https://example.com', 'title' => 'Example', 'author' => { 'name' => 'Author' },
      'future' => true, 'show_drafts' => true, 'unpublished' => true, 'quiet' => true,
      'plugins_dir' => File.expand_path('../_plugins', __dir__))
    Jekyll::Site.new(configuration).process
    path = File.join(configuration['destination'], 'substack-feed.xml')
    feed = Nokogiri::XML(File.read(path)) { |parser| parser.strict.nonet }
    items = feed.xpath('/rss/channel/item')
    assert_equal 26, items.length
    assert_equal 26, items.map { |item| item.at_xpath('guid').text }.uniq.length
    assert_equal 'ready', feed.at_xpath('//export:status', SubstackExport::NAMESPACES).text
    items.each do |item|
      assert_equal item.at_xpath('link').text, item.at_xpath('guid').text
      assert_includes item.at_xpath('content:encoded', SubstackExport::NAMESPACES).text, 'Second full-text paragraph &amp; detail.'
      assert_equal 2025, Time.rfc2822(item.at_xpath('pubDate').text).year
    end
    before = File.read(path)
    Jekyll::Site.new(configuration).process
    assert_equal before, File.read(path)
  end
end