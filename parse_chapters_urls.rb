require 'nokogiri'
require './worm'

toc_tag = "//article[@id='post-2404']//a"
excess_tag = "//article[@id='post-2404']//div[@id='jp-post-flair']//a"


doc = Nokogiri::HTML IO.read(Worm::TOC_HTML)

links = []


# get each chapter url, we are actually getting a few more...

doc.xpath(toc_tag).each do |link|
  links << link['href'] # if link.content.to_s.match('\d+')
end

# remove the links in excess (we know exacly where they come from)

doc.xpath(excess_tag).each do |link|
  links.delete(link['href'])
end
                                                                        
paths = links.map { |link| link.gsub(Worm::URL,'').gsub('http://','') }
#ensure that each path ends in /
paths = paths.map{|path| "#{path}/".gsub("//","/")}
paths.uniq!
IO.write Worm::PATHS, Marshal.dump(paths)
