Helpers.require_dir(File.expand_path("../selector/models",
                                     File.dirname(__FILE__)))

task :console do
  require 'irb'
  ARGV.clear
  include Selector::Models
  IRB.start
end