## This script prints a correct version of Book.txt in
#  the directory given as an argument.
#  It is highly dependent on Worm module and on preconcepts
#  to find its destinations files, so it has little to no
#  portability.

require './worm'

# Need to know how the various chapters.md are named
chapters = Marshal.load IO.read(Worm::CHAPTERS)

# TODO: make a premade preface.md to put between tableofcontents and
# mainmatter
base_str = "cover\nfrontmatter:\nmaketitle\ntableofcontents\nmainmatter:\n"

chapters[:names].each do |name|
  base_str = "#{base_str}#{name}.md\n"
end

# Backup done in the Rakefile
IO.write Worm::BOOK, base_str

