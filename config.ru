require 'rubygems'
require 'sinatra/base'

require './main'

use Rack::Static, :urls => ["/css", "/images", "/js"], :root => "public"

run ZFS_web
