#!/usr/bin/env ruby

require 'sinatra'
require 'base64'
require 'byebug'

post '/api/new_name' do
  status 201
end

post '/api/:color/points' do
  status 201
end

delete '/api/:color/points' do
  status 201
end

put '/api/debug' do
  puts Base64.decode64(request.body.string)
end
