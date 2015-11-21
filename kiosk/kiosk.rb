#!ruby

require './bundle/bundler/setup'

require 'sinatra'

class Scoreboard
end

get '/foo' do
  puts 'foo'
end
