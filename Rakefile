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
    :names => paths.map { |path| path.split('/')[path.split('/').size - 1]}
  }
  IO.write Worm::CHAPTERS, Marshal.dump(chapters)
end


task :test_chapters => Worm::CHAPTERS do
  chapters = Marshal.load IO.read(Worm::CHAPTERS)
  chapters[:names].each {|n| puts n}
end

task :get_chapters => Worm::CHAPTERS do
  chapters = Marshal.load IO.read(Worm::CHAPTERS)
  mkdir_p Worm::CHAPTERS_HTML_HOLDER
end

