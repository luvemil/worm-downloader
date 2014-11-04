require 'nokogiri'
require 'rake'
require './worm'

article_tag = "//div[@class='entry-content']"
title_tag = "//h1[@class='entry-title']"
html_file = ARGV[0]

doc = Nokogiri::HTML IO.read(html_file) if File.exists?(html_file)

chapter_node = doc.xpath(article_tag)


if chapter_node
  chapter_name = doc.xpath(title_tag).text
  chapter_parsed = [chapter_name] 
  chapter_text = chapter_node.text.gsub("\n","\n\n")
  chapter_parsed << chapter_text
  md_text = "\##{chapter_name}\n\n#{chapter_text}"
else
  chapter_parsed = [ "", "" ]
end

#dest_file = html_file.pathmap("#{Worm::CHAPTERS_TEXT_DIR}/%n.md")

# This time we print the output to stdout, let the Rakefile do
# the rest
print md_text
