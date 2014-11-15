# should find occurrences of something in the html of the novel

require './worm'
require 'rake'
require 'nokogiri'

chapters = Marshal.load(IO.read(Worm::CHAPTERS))

base_names = FileList.new chapters[:names]

html_files = base_names.pathmap("#{Worm::CHAPTERS_HTML_HOLDER}/%n.html")

def do_stuff(html)
  doc = Nokogiri::HTML IO.read(html)
  return doc.css("div.entry-content").css("p").size
end

def do_string(html)
  doc = Nokogiri::HTML IO.read(html)
  string = ""
  doc.css("div.entry-content").css("p").each do |key|
    string = "#{string}, #{key['style']}" if key['style']
  end
  return string
end

def do_classes(html)
  doc = Nokogiri::HTML IO.read(html)
  arr = []
  doc.css("div.entry-content").css("p").each do |key|
    if key['style'] 
      arr << key['style'] unless arr.include?(key['style'])
    end
  end
  return arr
end 

arr = []
html_files.each do |file|
  #puts "Found: #{do_string(file)} in #{file}" if File.exists?(file)
  arr += do_classes(file)
end

puts arr.uniq

