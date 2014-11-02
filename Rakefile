require 'net/http'
require './worm'

task :toc => Worm::TOC_HTML
task :urls => Worm::PATHS

file Worm::TOC_HTML do
  mkdir_p Worm::TOC_HTML.pathmap('%d')
  ruby 'download_toc.rb'
end
 
file Worm::PATHS => Worm::TOC_HTML do
  ruby 'parse_chapters_urls.rb'
end

desc "building #{Worm::CHAPTERS}"
task :chapters => Worm::CHAPTERS 

file Worm::CHAPTERS => Worm::PATHS do
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


task :test_chapters => Worm::CHAPTERS do
  chapters = Marshal.load IO.read(Worm::CHAPTERS)
  chapters[:names].each {|n| puts chapters[:links][n]}
end

task :get_chapters => Worm::CHAPTERS do
  chapters = Marshal.load IO.read(Worm::CHAPTERS)
  chapters_dir = Worm::CHAPTERS_HTML_HOLDER
  mkdir_p chapters_dir
  SOURCE_FILES = FileList.new(chapters[:names])
  SOURCE_FILES.pathmap("#{chapters_dir}/%f.html").each do |name|
    path = chapters[:links][name.pathmap("%n")]
    IO.write name, Worm::download_chapter(path)
  end
end

source_files = FileList.new("#{Worm::CHAPTERS_HTML_HOLDER}/*.html")

parsed_files = source_files.pathmap("#{Worm::CHAPTERS_TEXT_DIR}/%n")

task :get_text => parsed_files



#nope
task :get_text => :get_chapters do
  chapters = Marshal.load IO.read(Worm::CHAPTERS)
  text_dir = Worm::CHAPTERS_TEXT_DIR
  chapters_dir = Worm::CHAPTERS_HTML_HOLDER
  mkdir_p text_dir
  SOURCE_FILES = FileList.new(chapters[:names]).pathmap("#{chapters_dir}/%n.html")
end
