#!/usr/bin/env ruby

require 'sinatra'
require 'byebug'

def decode_ifconfig(ifconfig)
  ifconfig.gsub("$", "\n").gsub(/^/, '    ')
end

get '/mothership' do
  `ifconfig  | grep -A1 en0 | tail -1 | cut -f2 -d' '`
end

post '/arduino' do
  puts decode_ifconfig request.body.string
end
