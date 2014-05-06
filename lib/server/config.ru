require 'rack'
require File.expand_path("../../config/boot", __FILE__)
require File.expand_path("../controller", __FILE__)

# builder = Rack::Builder.new do
#   run Controller.new
# end
#
# Rack::Handler::Mongrel.run builder, :Port => App.config.rack.port
Rack::Handler::Mongrel.run Controller.new, :Port => App.config.rack.port