require './stash'
require 'net/http'
require 'nokogiri'

module Worm
  URL = "parahumans.wordpress.com"
  TOC = "/table-of-contents/" 
  TOC_HTML = "files/table_of_contents.html"

  def self.get_toc
    ObjectStash.store Net::HTTP.get(URL,TOC), "files/table_of_contents.html.stash"
  end

  def self.get_paths
    toc_file = 'files/table_of_contents.html.stash'
    toc_tag = "//article[@id='post-2404']//a"

    source = ObjectStash.load toc_file

    doc = Nokogiri::HTML(source)

    links = []


    # get each chapter url, we are actually getting a few more...

    doc.xpath(toc_tag).each do |link|
      links << link['href'] # if link.content.to_s.match('\d+')
    end

    # remove the links in excess (we know exacly where they come from)

    doc.xpath("//article[@id='post-2404']//div[@id='jp-post-flair']//a").each do |link|
      links.delete(link['href'])
    end



    paths = links.map { |link| link.gsub(@@url,'').gsub('http://','') }
    ObjectStash.store paths, "files/paths.stash"
  end

  def self.get_index
    paths 
  end

end
 
