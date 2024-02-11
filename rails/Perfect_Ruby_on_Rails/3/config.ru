require "rack"
# module function Kernel.#require_relative
# 現在のファイルからの相対パスで require します
require_relative "app"
require_relative "simple_middleware"

use Rack::Runtime
use SimpleMiddleware
run App.new
