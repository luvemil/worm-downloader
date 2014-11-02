require 'net/http'
require './worm'

file = File.new Worm::TOC_HTML, "w"

file.write Net::HTTP.get(Worm::URL,Worm::TOC)

file.close
