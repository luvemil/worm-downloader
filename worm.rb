require 'net/http'

module Worm
  URL = "parahumans.wordpress.com"
  TOC = "/table-of-contents/" 
  TOC_HTML = "files/table_of_contents.html"
  PATHS = "files/paths"
  CHAPTERS = "files/chapters"
  CHAPTERS_HTML_HOLDER = "files/html"

  def self.download_chapter path
    return Net::HTTP.get URL, path
  end
end
 
