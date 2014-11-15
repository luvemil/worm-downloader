# should find occurrences of something in the html of the novel

require './worm'
require 'rake'
require 'nokogiri'

chapters = Marshal.load(IO.read(Worm::CHAPTERS))

base_names = FileList.new chapters[:names]

html_files = base_names.pathmap("#{Worm::CHAPTERS_HTML_HOLDER}/%n.html")

def do_stuff(html)
  doc = Nokogiri::HTML IO.read(html)
  return doc.css("div.entry-content").css("br").size
end

html_files.each do |file|
  puts "There are #{do_stuff(file)} <p></p> tag enclosures in #{file}" if File.exists?(file)
end


