module Helpers
  def self.require_dir(path)
    Dir["#{path}/*.rb"].each { |file| require file }
  end
end