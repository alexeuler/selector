Helpers.require_dir(File.expand_path("../selector/models/crawler",
                                     File.dirname(__FILE__)))
require_relative '../selector/features'


desc "Runs the console with db connections up"
task :console do
  require 'irb'
  ARGV.clear
  include Selector
  include Selector::Models::Crawler
  @features = Features.new
  @features.async.start
  IRB.start
end