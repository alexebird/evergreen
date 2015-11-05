$:.unshift(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib'))
require 'evergreen'

RSpec.configure do |c|
  def mkevents(lst)
    lst.map do |e|
      Evergreen::Event.new(e)
    end
  end

  def mkpayloads(lst)
    lst.map do |e|
      Evergreen::Payload.new(e)
    end
  end
end
