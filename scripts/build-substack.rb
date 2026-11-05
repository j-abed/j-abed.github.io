require 'jekyll'

Jekyll::PluginManager.require_from_bundler
require_relative '../_plugins/substack_export'

Jekyll::Commands::Build.process(
  'destination' => ARGV.fetch(0, '_site'),
  'incremental' => false,
  'future' => false,
  'show_drafts' => false,
  'unpublished' => false
)