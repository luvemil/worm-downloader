require 'net/http'
require './worm'

task :toc => Worm::TOC_HTML
task :urls => Worm::PATHS
desc "building #{Worm::CHAPTERS}"
task :chapters => Worm::CHAPTERS 

## begin -- Get Table of Contents
directory Worm::TOC_HTML.pathmap('%d')
file Worm::TOC_HTML => Worm::TOC_HTML.pathmap('%d') do
  ruby 'download_toc.rb'
end
## end -- Get Table of Contents
 
## begin -- Get chapters' urls from Table of Contents
file Worm::PATHS => Worm::TOC_HTML do
  ruby 'parse_chapters_urls.rb'
end
## end

## begin -- build chapter list
file Worm::CHAPTERS => Worm::PATHS do
  puts "Doing #{Worm::CHAPTERS}"
  paths = Marshal.load IO.read(Worm::PATHS)
  chapters = {
    :paths => paths,
    :names => paths.map { |path| path.split('/')[path.split('/').size - 1]},
    :links => Hash.new
  }
  paths.each do |path|
    chapters[:links][path.split('/')[path.split('/').size - 1]] = path
  end
  IO.write Worm::CHAPTERS, Marshal.dump(chapters)
end
## end

## begin -- download chapters, require two runs
if File.exists?(Worm::CHAPTERS) 
  chapters = Marshal.load IO.read(Worm::CHAPTERS)
  chapters_dir = Worm::CHAPTERS_HTML_HOLDER
  directory chapters_dir
  SOURCES = FileList.new(chapters[:names])
  OUTPUTS = SOURCES.pathmap("#{chapters_dir}/%f.html")
  task :get_chapters => [ chapters_dir ] + OUTPUTS
else
  task :get_chapters
end

rule ".html" do |t|
  name = t.name
  puts "Doing #{name.pathmap("%n")}"
  path = chapters[:links][name.pathmap("%n")]
  IO.write name, Worm::download_chapter(path)
end
## end

## begin -- get text from chapter.html
directory Worm::CHAPTERS_TEXT_DIR
source_files = FileList.new("#{Worm::CHAPTERS_HTML_HOLDER}/*.html")
parsed_files = source_files.pathmap("#{Worm::CHAPTERS_TEXT_DIR}/%n.parsed")

task :get_text => [ Worm::CHAPTERS_TEXT_DIR ] + parsed_files  

rule ".parsed" => ->(f){source_file(f)} do |t|
  puts "Found #{t}"
  ruby "parse_html.rb #{t.source}"
end

def source_file f
  return f.pathmap("#{Worm::CHAPTERS_HTML_HOLDER}/%n.html")
end
## end

## begin -- make md files for softcover from html
#  uses source_files defined above
#  TODO: run sc new files/book from Rakefile
#  (need to be sure it runs only once)
directory Worm::BOOK_DIR
md_files = source_files.pathmap("#{Worm::BOOK_DIR}/%n.md")

task :get_md => [ Worm::BOOK_DIR ] + md_files

rule ".md" => ->(f){source_file(f)} do |t|
  puts "Making #{t.name}"
  #ruby "md_builder.rb #{t.source} > #{t.name}"
  ruby "parse_md.rb #{t.source} > #{t.name}"
end
## end

## deploy book
directory Worm::BOOK.pathmap("%d")
task :sc_deploy => [ :get_md, Worm::CHAPTERS, Worm::BOOK.pathmap("%d") ] do
  #sh "mv #{Worm::BOOK}\{,.bak\}" if File.exists?(Worm::BOOK)
  ruby "update_book.rb #{Worm::BOOK}"
end
 
task :default => [:chapters, :get_chapters, :get_text, :get_md]
