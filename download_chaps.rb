require './stash'
require 'net/http'
require 'nokogiri'

url = 'parahumans.wordpress.com' 
article_tag = "//div[@class='entry-content']"
title_tag = "//h1[@class='entry-title']"

paths = ObjectStash.load 'files/paths.stash'

chapter_names = Hash.new

err = []

paths.each do |path|
  # Ensure that path ends in "/"
  path = (path+'/').gsub('//','/')

  # Get a string to name a chapter from its path
  path_splitted = path.split('/')
  n = path_splitted.size - 1 
  filename = "files/chapters/#{path_splitted[n]}.stash"
  htmlfile = "files/html/#{path_splitted[n]}.stash"

  unless File::exists? filename
    # Get the html and transform into a NodeSet
    if File::exists? htmlfile
      source = ObjectStash.load htmlfile
    else
      source = Net::HTTP.get url, path
      ObjectStash.store source, htmlfile
    end
    doc = Nokogiri::HTML source

    # Parse the NodeSet
    chapter_names[path] = doc.xpath(title_tag)[0].content
    chapter_node = doc.xpath(article_tag)[0]

    if chapter_node
      ObjectStash.store chapter_node.content.to_s, filename
    else
      File::new "files/err/#{path_splitted[n]}", "w"
      puts path+" Not Found"
      err << path
    end
      
  end

  ObjectStash.store err, "files/err.stash"
  # aggiungi una chiamata per salvare chapter_names su disco
  # e magari modifica il controllo su per farlo checkare

end

