

desc "Runs the console with db connections up"
task :console do
  require 'irb'
  require_relative "../config/boot"
  ARGV.clear
  include Selector
  include Selector::Models::Crawler
  IRB.start
end