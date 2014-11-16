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
# Ask user input
#require 'highline/import'

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
NONP_TAGS = %W[span li ul h3 div em address strong blockquote]
P_TAGS = %W[em br del strong span i b]
NONP_ONLY_TAGS = NONP_TAGS - P_TAGS

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
    doc.css("div.entry-content p").each do |node|
    #doc.css("div.entry-content").each do |node|
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

# Try to figure out what to do with tags outside <p></p>
def is_in_p node, root
  if node.parent.name == "p"
    return true
  elsif node.parent == root
    return false
  end
  return is_in_p node.parent, root
end

def search_nonp_tags html_files
  nonp_tags = []
  html_files.each do |file|
    doc = Nokogiri::HTML IO.read(file)
    root = doc.css("div.entry-content")[0]
    TAGS.each do |tag|
      root.css(tag).each do |node|
        unless is_in_p( node, root )
          nonp_tags << tag
        end
      end
      nonp_tags = nonp_tags.uniq
    end
  end
  puts "Tags outside <p></p> are:"
  puts nonp_tags
end

# Shows the content of a node on request, uses the auxiliary function
def prompt(*args)
    print(*args)
    gets
end

def show_content node
  input = prompt "Found #{node.name} tag, show? "
  puts "#{node.text}" unless input == "N"
  input = prompt "Continue:"
end

# Manipulates contents inside nonp_tags
def nonp_tags_content html_files
  nonp_content = {}
  html_files.each do |file|
    doc = Nokogiri::HTML IO.read(file)
    root = doc.css("div.entry-content")[0]
    NONP_TAGS.each do |tag|
      nonp_content[tag]=[]
      root.css(tag).each do |node|
        if NONP_ONLY_TAGS.include? tag
          nonp_content[tag] << node.text
          #show_content node
        else
          unless is_in_p(node, root)
            nonp_content[tag] << node.text
            #show_content node
          end
        end
        nonp_content[tag] = nonp_content[tag].uniq
      end
    end
  end
  NONP_TAGS.each do |tag|
    prompt "Showing content for #{tag} tag: "
    puts nonp_content[tag]
  end
  #ObjectStash.store  ObjectStash.store nonp_content, "nonp_content.stash"
end



# Is there any html_file with multiple div.entry-content?
# Answer: No!
def multiple_div html_files
  multiple = []
  html_files.each do |file|
    doc = Nokogiri::HTML IO.read(file)
    if doc.css("div.entry-content").size > 1
      multiple << file.pathmap("%n")
    end
  end
  if multiple == []
    puts "No multiple div.entry-content"
  else
    puts multiple
  end
end


def main html_files
  search_tags html_files
end

main html_files
