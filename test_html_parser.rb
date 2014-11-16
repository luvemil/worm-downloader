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

def main html_files
end

main html_files
