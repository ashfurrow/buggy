# frozen_string_literal: true

require 'sinatra/base'

module SlackBuggybot
  class Web < Sinatra::Base
    get '/' do
      'Heroku needs this port bound, so here is a Sinatra server.'
    end
  end
end
