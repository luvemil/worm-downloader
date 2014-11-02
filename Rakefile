require './stash'
require 'net/http'
require './worm'

task :toc => Worm::TOC_HTML
task :urls => Worm::PATHS

file Worm::TOC_HTML do
  ruby 'download_toc.rb'
end
 
file Worm::PATHS => Worm::TOC_HTML do
  ruby 'parse_chapters_urls.rb'
end

task :chapters do
  file Worm::CHAPTERS => Worm::PATHS do
    paths = Marshal.load IO.read(Worm::PATHS)
    chapters = {
      :paths => paths,
      :names => paths.map { |path| path.split('/')[path.split('/').size - 1]}
    }
    IO.write Worm::CHAPTERS, Marshal.dump(chapters)
  end
  chapters = Marshal.load IO.read(Worm::CHAPTERS)
end

