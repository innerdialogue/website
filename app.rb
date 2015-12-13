require 'tilt/haml'

module Indigo

  class Application < Sinatra::Application

    def self.load_rb_dir dir
      Dir["#{dir}/*.rb"].sort.each { |rb| require File.join(File.dirname(__FILE__), rb) }
    end

    configure do
    end

    get '/?' do
      haml :index
    end

  end

end
