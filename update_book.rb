## This script prints a correct version of Book.txt in
#  the directory given as an argument.
#  It is highly dependent on Worm module and on preconcepts
#  to find its destinations files, so it has little to no
#  portability.

require './worm'

# Need to know how the various chapters.md are named
chapters = Marshal.load IO.read(Worm::CHAPTERS)
names = chapters[:names]

# BEGIN - putting in Book.txt just the chapters we want.
# Get the start and end chapter from the arguments (if valid)
if ARGV.length >= 2
  start_chap = ARGV[0]
  end_chap = ARGV[1]
else
  start_chap = nil
  end_chap = nil
end

if names.include?(start_chap) and names.include?(end_chap)
  # Something might get ugly if we run something like `ruby update_book.rb
  # chapter3 chapter1`?
  range = names.index(start_chap)..(names.index(end_chap))
  names = names[range]
end
# END

# TODO: make a premade preface.md to put between tableofcontents and
# mainmatter
base_str = "cover\nfrontmatter:\nmaketitle\ntableofcontents\nmainmatter:\n"

names.each do |name|
  base_str = "#{base_str}#{name}.md\n"
end

# Backup done in the Rakefile
IO.write Worm::BOOK, base_str

