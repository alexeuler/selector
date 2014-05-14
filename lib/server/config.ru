#\ -p 9010 -E production
require 'rack'
require File.expand_path("../../config/boot", __FILE__)
require File.expand_path("../controller", __FILE__)

$logger = Logger.new(File.expand_path("../../../log/selector.log", __FILE__))
rack_logger = File.new(File.expand_path("../../../log/rack.log", __FILE__), "w+")
use Rack::CommonLogger, rack_logger
run Controller.new

