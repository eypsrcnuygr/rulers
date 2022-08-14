# frozen_string_literal: true

require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"

module Rulers
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404,
          {'Content-Type' => 'text/html'}, []]
      end
      klass, act = get_controller_and_action(env)
      controller = klass&.new(env)
      begin
        text = controller.send(act)
        if controller.class.to_s == 'HomeController'
          return [302,
            {'Content-Type' => 'text/html'}, [text]]
        end
      [200, { 'Content-Type' => 'text/html' },
       [text]]
      rescue => exception
        [404, { 'Content-Type' => 'text/html' },
        ["Error: #{exception}"]]
      end
    end
  end
end
