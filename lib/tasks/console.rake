Helpers.require_dir(File.expand_path("../selector/models/crawler",
                                     File.dirname(__FILE__)))
require_relative '../selector/feature_loader'


desc "Runs the console with db connections up"
task :console do
  require 'irb'
  ARGV.clear
  include Selector
  include Selector::Models::Crawler
  IRB.start
end