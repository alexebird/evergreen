#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib'))
require 'evergreen'

sock = Evergreen::Socket.new
sock.bind
sock.listen do |seq|
  puts "seq=#{seq.inspect}"
end
