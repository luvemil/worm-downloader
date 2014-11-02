require 'nokogiri'
require 'rake'
require './worm'

article_tag = "//div[@class='entry-content']"
title_tag = "//h1[@class='entry-title']"
html_file = ARGV[0]

doc = Nokogiri::HTML IO.read(html_file) if File.exists?(html_file)

chapter_node = doc.xpath(article_tag)[0]


if chapter_node
  chapter_name = doc.xpath(title_tag)[0].content
  chapter_parsed = [chapter_name] 
  chapter_parsed << chapter_node.content.to_s
else
  chapter_parsed = [ "", "" ]
end

dest_file = html_file.pathmap("#{Worm::CHAPTERS_TEXT_DIR}/%n.parsed")

IO.write dest_file, Marshal.dump(chapter_parsed)
