require './stash'
require 'net/http'
require 'nokogiri'

url = 'parahumans.wordpress.com' 

paths = ObjectStash.load 'files/paths.stash'


paths.each do |path|
  source = Net::HTTP.get(url,path)
  doc = Nokogiri::HTML(source)
  n = path.split('/').size
  ObjectStash.store doc.xpath("//div[@class='entry-content']")[0].content.to_s, "files/#{path.split('/')[n]}.stash"
end

