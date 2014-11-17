require 'net/http'

module Worm
  URL = "parahumans.wordpress.com"
  TOC = "/table-of-contents/" 
  TOC_HTML = "files/table_of_contents.html"
  PATHS = "files/paths"
  CHAPTERS = "files/chapters"
  CHAPTERS_HTML_HOLDER = "files/html"
  CHAPTERS_TEXT_DIR = "files/contents"
  BOOK = "files/book/Book.txt"
  BOOK_DIR = "files/book/chapters"

  def self.download_chapter path
    puts "Download #{path}"
    return Net::HTTP.get URL, path
  end

  def self.show_me node
    strings = ""
    node.children.each do |child|
      if child.text == ""
      else 
        strings += self.convert(child)
      end
    end
    return strings
  end 

  def self.convert child
    # Converts an html tag to the markdown equivalent, returns a string.
    # Assumes the input is a well formatted HTML snippet, i.e. no
    # nested <strong> or <em>
    tag = child.name
    if tag == "em"
      return "_#{self.show_me(child)}_"
    elsif tag == "strong"
      return  "**#{self.show_me(child)}**"
    elsif tag == "text"
      return child.text
    end
    return child.text
  end

end
 
