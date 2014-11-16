# This code is a bunch of experiments I did to realize what kind
# of html tags I had to deal with. It contains methods to find
# which tags there are, what are their attributes, size, etc
# I also defined some constants to hold these results after I found 'em
# so that I could use it more easily.
#
# Everything is written more or less chronologically, except for the
# main

require './worm'
require 'rake'
require 'nokogiri'

chapters = Marshal.load(IO.read(Worm::CHAPTERS))

base_names = FileList.new chapters[:names]

html_files = base_names.pathmap("#{Worm::CHAPTERS_HTML_HOLDER}/%n.html")

# Notice, I'm pretty sure that each tags appears only inside <p></p>
# UPDATE: apparently some tag does not appear inside <p></p>, but I haven't
# cleaned the links at the beginning and at the end so I should do that
# first
TAGS = %W[p em br del strong span i b li ul h3 div address blockquote] #also a and text
ATTRIBUTES = {
  "p" => %W[style dir id align],
  "em" => ["style"],
  "strong" => ["style"],
  "span" => %W[class style id title],
  "li" => ["class"],
  "div" => %W[id class data-src data-name style],
  "address" => ["style"]
}

def count_stuff(html)
  doc = Nokogiri::HTML IO.read(html)
  return doc.css("div.entry-content").css("span").size
end

def do_string(html)
  doc = Nokogiri::HTML IO.read(html)
  string = ""
  doc.css("div.entry-content").css("p").each do |p_node|
    string = "#{string}, #{p_node['style']}" if p_node['style']
  end
  return string
end

def do_classes(html)
  doc = Nokogiri::HTML IO.read(html)
  arr = []
  doc.css("div.entry-content").css("p").each do |p_node|
    if p_node['style'] 
      arr << p_node['style'] unless arr.include?(p_node['style'])
    end
  end
  return arr
end 

def search_1 html_files
  html_files.each do |file|
    n = 0
    n = count_stuff(file) if File.exists?(file)
    puts "Found #{n} tags in #{file}" unless n == 0
  end
end

def search_2 html_files
  arr = []
  html_files.each do |file|
    arr += do_classes(file)
  end
  puts arr.uniq
end

# Now let's find out everything

# Given a Nokogiri Node returns the tags of all its children
def get_all_tags node
  arr = []
  if node.children.size == 0
    return []
  else
    node.children.each {|child| arr += get_all_tags(child)}
  end
  node.children.each {|child| arr << child.name}
  return arr.uniq #Let's clean stuffs a bit
end

# Use the previous function to find all the tags
# under div.entry-content p
def search_tags html_files
  tags_array = []
  html_files.each do |file|
    doc = Nokogiri::HTML IO.read(file)
    # Uncomment to search only inside p tags
    #doc.css("div.entry-content p").each do |node|
    doc.css("div.entry-content").each do |node|
      tags_array += get_all_tags(node)
      tags_array = tags_array.uniq
    end
  end
  puts tags_array
end

# Get attributes of a given node
# e.g. if I encounter <p style='something'></p> what I want
# is "style"
def get_attributes node
  if node.attributes
    return node.attributes.keys
  else
    return []
  end
end

# Search for all attributes of all tags
def search_attributes html_files
  attributes = {}
  TAGS.each {|tag| attributes[tag]=[]}
  html_files.each do |file|
    doc = Nokogiri::HTML IO.read(file)
    TAGS.each do |tag|
      doc.css("div.entry-content #{tag}").each do |node|
        attributes[tag] += get_attributes(node)
      end
      attributes[tag] = attributes[tag].uniq
    end
  end
  TAGS.each do |tag|
    puts "Found attributes #{attributes[tag]} for tag #{tag}"
  end
end


def main html_files
  search_attributes html_files
end

main html_files
