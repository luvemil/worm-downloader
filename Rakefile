require './stash'
require 'net/http'
require './worm'

task :toc => Worm::TOC_HTML

file Worm::TOC_HTML do
  ruby 'download_toc.rb'
end
 
url = "parahumans.wordpress.com"
toc = "/table-of-contents/"

IOTools = ObjectStash


file "files/table_of_contents.html.stash" do
  Worm::get_toc
  #ruby 'downloader.rb'
  #IOTools.store Net::HTTP.get(url,toc), "files/table_of_contents.html.stash"
end

file "files/paths.stash" => "files/table_of_contents.html.stash" do
  Worm::get_paths
  #ruby 'get_chapters_urls.rb'
  #doc = Nokogiri::HTML(IOTools.load "files/table_of_contents.html.stash")
end

# facciamo un prototipo cosi mi chiarisco le idee

file "files/index.stash" => "files/paths.stash" do

end


index = [] # prendi l'indice
paths = [] # prendi gli indirizzi

# sta roba fa abbastanza schifo... dovrei fixare i 
# riferimenti a paths e index..

#paths.each do |path|
#  file "files/#{name}.html.stash" do
#    source = Net::HTTP.get(url,path)
#    ObjectStash.store source, "files/#{name}.html.stash"
#  end
#end
#
#
#index.each do |name|
#  html_file = "files/html/#{name}.stash"
#  chapter_content = "files/chapters/#{name}.stash"
#  file chapter_content => html_file do
#    doc = Nokogiri::HTML(html_file)
#    #porcate varie
#  end
#end
