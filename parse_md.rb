require 'nokogiri'
require './worm'

ARTICLE_TAG="div.entry-content"
TITLE_TAG = "h1.entry-title"

html_file = ARGV[0]
doc = Nokogiri::HTML IO.read html_file

root = doc.css ARTICLE_TAG

def show_me node
  strings = ""
  node.children.each do |child|
    strings += convert(child)
  end
  return strings
end 

def show_text node
  # Here we do some basic escape to avoid issues.
  # This is intended as a substitution done *before* any parsing has
  # happened.
  return node.text.gsub('*', '\*')
end

def convert child
  # Converts an html tag to the markdown equivalent, returns a string.
  # Assumes the input is a well formatted HTML snippet, i.e. no
  # nested <strong> or <em>
  tag = child.name
  # First we go with tags that can be empty
  if tag == "br"
    return "#{show_me(child)}\\\\"
    # Now everything from here on must have content
  elsif child.text == ""
    return ""
  elsif tag == "em"
    return "_#{show_me(child).strip}_ "
  elsif tag == "strong"
    return  "**#{show_me(child).strip}** "
  elsif tag == "text"
    return show_text(child)
  elsif tag == "p"
    # Here goes everything to do with p tags... maybe this deserves
    # its own function.
    if child["style"] == 'padding-left:30px;' or child["style"] == 'text-align:left;padding-left:30px;' or child["style"] == 'padding-left:60px;'
      return ">#{show_me(child)}\n\n"
    end
    return "#{show_me(child)}\n\n"
  end
  return show_text(child)
end

def post_production string
  tmp = string.gsub('****','')
  tmp = tmp.gsub("  "," ")
  tmp = tmp.gsub(" ?","?")
  tmp = tmp.gsub(" ,",",")
  tmp = tmp.gsub(" .",".")
  # Remove space before right double quotation mark
  tmp = tmp.gsub(" \u{201d}","\u{201d}")
  tmp = tmp.gsub(" \u{201c}","\u{201c}")
  return tmp
end

def parse root
  root.css("p").each do |node|
    # We do some postproduction here
    print post_production(convert(node)) unless node.css("a").size > 0
  end
end

puts "\##{doc.css(TITLE_TAG).text}\n\n"

parse root

