require 'net/http'
require 'nokogiri'
require './stash' 

url = 'http://parahumans.wordpress.com'
toc= '/table-of-contents/'

source = Net::HTTP.get(url,toc + name)
doc = Nokogiri::HTML(source)

ObjectStash.store doc, "table_of_contents"

