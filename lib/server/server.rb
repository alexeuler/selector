require 'rack'
require_relative "../config/boot"
require_relative "controller"

app = Proc.new do |env|
  controller = Controller.new
  controller.call(env)
end

Rack::Handler::Mongrel.run app, :Port => App.config.rack.port