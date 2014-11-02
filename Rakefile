require './stash'
require 'net/http'

url = "parahumans.wordpress.com"
toc = "/table-of-contents/"

IOTools = ObjectStash

task :toc => "files/table_of_contents.html.stash"

file "files/table_of_contents.html.stash" do
  ruby 'downloader.rb'
  #IOTools.store Net::HTTP.get(url,toc), "files/table_of_contents.html.stash"
end

file "files/chapters_urls.stash" => "files/table_of_contents.html.stash" do
  ruby 'get_chapters_urls.rb'
  #doc = Nokogiri::HTML(IOTools.load "files/table_of_contents.html.stash")
end

