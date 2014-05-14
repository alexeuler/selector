desc "Runs the server daemon"
task :server do
  root = File.expand_path("../..",File.dirname(__FILE__))
  system "cd #{root}/lib/server && rackup -D"
end