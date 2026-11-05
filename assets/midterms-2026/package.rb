require 'base64'
require 'fileutils'
require 'nokogiri'
require 'tmpdir'
require 'uri'

root = File.expand_path('../..', __dir__)
preview = ARGV.fetch(0, '/tmp/j-abed-midterms-preview')
document = Nokogiri::HTML(File.read(File.join(preview, 'one-parameter-model-2026-midterms.html')))
article = document.at_css('.post')
raise 'Expected the full article with six native figures' unless article && article.css('.midterms-figure svg').length == 6

archive = File.join(__dir__, 'midterms-2026-blog-package.zip')
Dir.mktmpdir('midterms-package-') do |temporary|
  name = 'midterms-2026-blog-package'
  folder = File.join(temporary, name)
  FileUtils.mkdir_p(folder)
  ['assets/midterms-2026', '_includes/midterms-2026'].each do |relative|
    destination = File.join(folder, relative)
    FileUtils.mkdir_p(destination)
    Dir.glob(File.join(root, relative, '*')).each do |source|
      next unless File.file?(source) && %w[.css .js .cjs .json .svg .png .md .html].include?(File.extname(source))
      FileUtils.cp(source, destination)
    end
  end
  FileUtils.mkdir_p(File.join(folder, 'source_info'))
  FileUtils.cp(File.join(root, 'source_info/midterms-2026-dashboard.html'), File.join(folder, 'source_info'))

  styles = document.css('head link[rel="stylesheet"]').filter_map do |link|
    path = URI.parse(link['href']).path
    next unless path.start_with?('/public/css/')
    File.read(File.join(root, path.delete_prefix('/')))
  end
  styles << File.read(File.join(__dir__, 'article.css'))
  styles << '.container.content{max-width:48rem;margin:0 auto;padding:2rem 1rem}body{margin:0}html{letter-spacing:0}'
  article.css('link, script').remove
  article.css('img[src]').each do |image|
    path = URI.parse(image['src']).path.delete_prefix('/')
    source = File.join(folder, path)
    raise "Missing image: #{path}" unless File.file?(source)
    mime = File.extname(source) == '.svg' ? 'image/svg+xml' : 'image/png'
    image['src'] = "data:#{mime};base64,#{Base64.strict_encode64(File.binread(source))}"
  end
  article.css('a[href]').each do |link|
    next unless link['href'].start_with?('/')
    path = link['href'].delete_prefix('/')
    raise "Missing linked file: #{path}" unless File.file?(File.join(folder, path))
    link['href'] = path
  end

  standalone = Nokogiri::HTML('<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title></title></head><body><main class="container content"></main></body></html>')
  standalone.at_css('title').content = article.at_css('h1').text
  style = Nokogiri::XML::Node.new('style', standalone)
  style.content = styles.join("\n")
  standalone.at_css('head').add_child(style)
  standalone.at_css('main').add_child(article)
  script = Nokogiri::XML::Node.new('script', standalone)
  script.content = File.read(File.join(__dir__, 'article.js'))
  standalone.at_css('body').add_child(script)
  File.write(File.join(folder, 'blog-post.html'), standalone.to_html)

  markdown = File.read(File.join(root, '_posts/2026-11-04-one-parameter-model-2026-midterms.md'))
  markdown = markdown.gsub(/<link\b[^>]*>\s*|<script\b[^>]*>[\s\S]*?<\/script>\s*/, '')
  markdown = markdown.gsub(/\{\{\s*'([^']+)'\s*\|\s*relative_url\s*\}\}/) { Regexp.last_match(1).delete_prefix('/') }
  markdown = markdown.gsub(/\{%\s*include\s+([^\s]+)\s*%\}/) do
    include_path = Regexp.last_match(1)
    if File.extname(include_path) == '.html'
      File.read(File.join(root, '_includes', include_path))
    else
      "<img src=\"_includes/#{include_path}\" alt=\"Chart described in the caption below\">"
    end
  end
  markdown = markdown.gsub('](/', '](')
  File.write(File.join(folder, 'blog-post.md'), markdown)
  File.write(File.join(folder, 'README.txt'), <<~TEXT)
    2026 MIDTERMS BLOG + INFOGRAPHIC PACKAGE

    Open blog-post.html in a browser for the full article. Its styling,
    six native charts, historical table, opening infographic, and chart interactions are
    embedded, so no Jekyll installation or internet connection is required.
    Supporting links work when the ZIP is fully extracted.

    blog-post.md: portable Markdown article with relative image links.
    assets/midterms-2026/summary-linkedin.png: portrait infographic (1200 x 1500).
    assets/midterms-2026/summary.svg: editable, scalable portrait infographic.
    assets/midterms-2026/summary-blog.svg: landscape article infographic.
    assets/midterms-2026/linkedin-draft.md: LinkedIn copy and image alt text.
    source_info/midterms-2026-dashboard.html: interactive companion dashboard.
    assets/midterms-2026/snapshot.json: the extracted data snapshot.
    _includes/midterms-2026/: the six individual SVG figures and historical table.

    To regenerate the graphics, run from this folder:
      node assets/midterms-2026/build-visuals.cjs

    STATUS: Article enabled for publication. Counts are preliminary and external sources
    are unverified. Retrospective classification accuracy is not a claim
    of pre-election forecasting performance. LinkedIn copy remains subject
    to factual review; packaging does not post anything to LinkedIn.
  TEXT
  raise 'ZIP creation failed' unless system('zip', '-q', '-r', File.join(temporary, 'package.zip'), name, chdir: temporary)
  FileUtils.mv(File.join(temporary, 'package.zip'), archive)
end
puts "Created #{archive} (#{File.size(archive)} bytes)"