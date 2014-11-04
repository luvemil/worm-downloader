require 'net/http'

module Worm
  URL = "parahumans.wordpress.com"
  TOC = "/table-of-contents/" 
  TOC_HTML = "files/table_of_contents.html"
  PATHS = "files/paths"
  CHAPTERS = "files/chapters"
  CHAPTERS_HTML_HOLDER = "files/html"
  CHAPTERS_TEXT_DIR = "files/contents"
  BOOK_DIR = "files/book/chapters"

  def self.download_chapter path
    puts "Download #{path}"
    return Net::HTTP.get URL, path
  end
end
 
