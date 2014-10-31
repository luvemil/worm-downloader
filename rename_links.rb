require './stash'

links = ObjectStash.load "files/chapters_urls.stash"

url = 'parahumans.wordpress.com' 

paths = links.map { |link| link.gsub(url,'').gsub('http://','') }

ObjectStash.store paths, "files/paths.stash"
