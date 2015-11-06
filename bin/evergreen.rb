#!/usr/bin/ruby

$:.unshift(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib'))
require 'evergreen'

logf = ARGV[0]
$logout = logf ? File.open(logf, 'w') : $stdout

sock = Evergreen::Socket.new
sock.bind
sock.listen do |seq|
  $logout.puts "seq=#{seq.inspect}"
end
