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

ROOT_TAG = "div.entry-content"

#TAGS = %W[p em br del strong span i b li ul h3 div address blockquote] #also a and text
TAGS = %W[em br del strong span i b]
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



#merges {attribute => [values] } 
def merge_hash first, second
  first.merge(second) do |tag, first_arr, second_arr| 
    (first_arr + second_arr).uniq
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


def get_attributes node
  if node.attributes
    return node.attributes.keys
  else
    return []
  end
end 

def attribute_values root, tags
  values = Hash.new {|hash, tag| hash[tag] = Hash.new { |in_hash, attribute| in_hash[attribute] = [] } }
  tags.each do |tag|
    root.css(tag).each do |node|
      get_attributes(node).each do |key|
        values[node.name][key] << node[key] unless values[node.name][key].include?(node[key])
      end
    end
  end
  return values
end

def find_attribute_values html_files
  # Define the tags we are looking for, we need tags nested inside p except
  # for p itself
  tags = P_TAGS.map {|tag| "p #{tag}"}
  tags << "p"
  values = {}
  html_files.each do |file|
    doc = Nokogiri::HTML IO.read(file)
    root = doc.css("div.entry-content")
    values = values.merge(attribute_values(root, tags)) {|key, a, b| merge_hash(a,b)}
  end
  show_attributes values
  return values
end

# Search a given tag and prints which file contains it
def is_in_here target, root
  return root.css("#{target[0]}[#{target[1]}=#{target[2]}]").size > 0
end
def wheres_the_attribute html_files
  # attribute = [tag, attribute, value]
  #target = ["span", "style", '"color:#333333;font-style:normal;line-height:24px;"']
  att = Worm::ATTRIBUTES
  target = ["p","style",att["p"]["style"][3] ]
  html_files.each do |file|
    doc = Nokogiri::HTML IO.read(file)
    root = doc.css(ROOT_TAG)
    puts "Found an occurrency of #{target[2]} in #{file}" if is_in_here(target, root)
  end
end
    

def main html_files
  find_attribute_values html_files
end

main ARGV
