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
      strings += self.convert(child)
    end
    return strings
  end 

  def self.show_text node
    # Here we do some basic escape to avoid issues.
    # This is intended as a substitution done *before* any parsing has
    # happened.
    return node.text.gsub('*', '\*')
  end

  def self.convert child
    # Converts an html tag to the markdown equivalent, returns a string.
    # Assumes the input is a well formatted HTML snippet, i.e. no
    # nested <strong> or <em>
    tag = child.name
    # First we go with tags that can be empty
    if tag == "br"
      return "#{self.show_me(child)}\\\\"
    # Now everything from here on must have content
    elsif child.text == ""
      return ""
    elsif tag == "em"
      return "_#{self.show_me(child).strip}_"
    elsif tag == "strong"
      return  "**#{self.show_me(child).strip}**"
    elsif tag == "text"
      return self.show_text(child)
    elsif tag == "p"
      # Here goes everything to do with p tags... maybe this deserves
      # its own function.
      if child["style"] == 'padding-left:30px;'
        return ">#{self.show_me(child)}\n\n"
      end
      return "#{self.show_me(child)}\n\n"
    end
    return self.show_text(child)
  end

  def self.parse root
    root.css("p").each do |node|
      # We do some postproduction here
      print self.convert(node).gsub('****','') unless node.css("a").size > 0
    end
  end

  # All the attributes I found
  ATTRIBUTES = {"p" => {
    "style" => %W[ 
                "text-align:right;"
                "text-align:center;"
                "padding-left:30px;"
                "text-align:left;"
                "text-align:left;padding-left:30px;"
                "padding-left:30px;text-align:center;"
                "text-align:center;padding-left:30px;"
                "padding-left:60px;" ],
                "dir" => %W[
                "ltr" ],
                  "id" => %W[
                "internal-source-marker_0.1750084241491393"
                "firstHeading" ],
                  "align" => %W[
                "LEFT"
                "CENTER"
                "center" ]
  },
  "span" => {
    "style" => %W[
                "text-decoration:underline;"
                "line-height:15px;"
                "color:#333333;font-style:normal;line-height:24px;"
                "font-style:inherit;line-height:1.625;"
                "font-size:15px;font-style:inherit;line-height:1.625;"
                "color:#ffffff;" ],
                  "id" => %W[
                "internal-source-marker_0.43876651558093727" ],
                  "class" => %W[
                "wp-smiley wp-emoji wp-emoji-wink"
                "wp-smiley wp-emoji wp-emoji-sad"
                "wp-smiley wp-emoji wp-emoji-mindblown" ],
                  "title" => %W[
                ";)"
                ":("
                "O_o" ]
  },
  "em" => {
    "style" => %W[
                "text-align:left;"
                "line-height:1.625;"
                "font-size:15px;line-height:1.625;" ]
  },
  "strong" => {
    "style" => %W[
                "padding-left:30px;" ]
  }
  }
end
 
