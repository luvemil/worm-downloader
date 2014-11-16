# This file is to experimenting with the tags I found with 
# find_occurrences.rb.

require './worm'
require 'rake'
require 'nokogiri'
# Ask user input
#require 'highline/import'

chapters = Marshal.load(IO.read(Worm::CHAPTERS))

base_names = FileList.new chapters[:names]

html_files = base_names.pathmap("#{Worm::CHAPTERS_HTML_HOLDER}/%n.html")


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


# Find everything from a given root node: tags, attributes and attribute
# values for each children
# return hash = { tag => { attribute => [ values ] } }
def attribute_values root, tags
  stuff = {}
  tags.each do |tag| 
    stuff[tag] = {} 
    root.css(tag).each do |node|
      node.attributes.each do |attribute|
        stuff[tag][attribute] = [] unless stuff[node.name][attribute]
        stuff[tag][attribute] = 
          (stuff[tag][attribute] + [ node[attribute] ]).uniq
      end
    end
  end
  return stuff
end

# merges hashes in the form { attribute => [values] }
def merge_hash first, second
  first.merge(second) do |key, first_array, second_array| 
    (first_array + second_array).uniq
  end
end
# Prints on screen each tag
def show_attributes values
  values.keys.each do |key|
    puts "#{key}:"
    values[key].keys.each do |attribute|
      puts "\t#{attribute}"
      values[key][attribute].each do |value|
        puts "\t\t#{value}"
      end
    end
  end
end

def find_attribute_values html_files
  values = {}
  html_files.each do |html|
    doc = Nokogiri::HTML IO.read(html)
    doc.css("div.entry-content").each do |root|
      values = values.merge(attribute_values(root, P_TAGS)) {|key, a, b| merge_hash(a,b)}
    end
  end
  show_attributes values
  return values
end 

def main html_files
  find_attribute_values html_files
end

main html_files
