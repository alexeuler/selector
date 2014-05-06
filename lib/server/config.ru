require 'rack'
require_relative "../config/boot"
require_relative "controller"

builder = Rack::Builder.new do
  run Controller.new
end

Rack::Handler::Mongrel.run builder, :Port => App.config.rack.port