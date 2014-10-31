#Downloads the table of contents and store the html with stash
require 'net/http'
require './stash' 

url = 'parahumans.wordpress.com'
toc= '/table-of-contents/'
dir='files'

source = Net::HTTP.get(url,toc)
ObjectStash.store source, "#{dir}/table_of_contents.html.stash"


