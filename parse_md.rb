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

def show_me node
  strings = ""
  node.children.each do |child|
    if child.name == "em"
      strings += "*#{show_me(child)}*"
    elsif child.name == "strong"
      strings += "_#{show_me(child)}_"
    elsif child.name == "text"
      strings += child.text
      return strings
    end
  end
  return strings
end

puts "\##{doc.css(TITLE_TAG).text}\n"
root.css("p").each do |node|
  puts parse(node) unless node.css("a").size > 0
  puts ""
end
