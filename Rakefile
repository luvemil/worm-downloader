require './stash'
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
    path = chapters[:links][FileList.new(name).pathmap("%n")[0]]
    IO.write name, Worm::download_chapter(path)
  end
end

