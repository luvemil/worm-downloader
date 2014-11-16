require 'nokogiri'
require './worm'

ARTICLE_TAG="div.entry-content"
TITLE_TAG = "h1.entry-title"

html_file = ARGV[0]
doc = Nokogiri::HTML IO.read html_file

root = doc.css ARTICLE_TAG

def parse node
  return node.text
end

puts "\##{doc.css(TITLE_TAG).text}\n"
root.css("p").each do |node|
  puts parse(node) unless node.css("a").size > 0
  puts ""
end
