require 'nokogiri'
require './stash'  

dir = 'files'
toc = 'table_of_contents.html.stash'

source = ObjectStash.load "#{dir}/#{toc}"

doc = Nokogiri::HTML(source)

links = []

# get each chapter url, we are actually getting a few more...
doc.xpath("//article[@id='post-2404']//a").each do |link|
  links << link['href'] # if link.content.to_s.match('\d+')
end

# remove the links in excess (we know exacly where they come from)
doc.xpath("//article[@id='post-2404']//div[@id='jp-post-flair']//a").each do |link|
  links.delete(link['href'])
end
ObjectStash.store links, "#{dir}/chapters_urls.stash"
