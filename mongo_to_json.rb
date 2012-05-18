require 'rubygems'
require 'mongo'
require 'json'

conn = Mongo::Connection.new
db   = conn['artmap']
coll = db['boston_public_art']

puts "There are #{coll.count} records in the collection."

markers = []

coll.find.each do |doc|
	markers << {
		"latitude" => doc['latitude'], 
		"longitude" => doc['longitude'], 
		"title" => doc['title'],
		"content" => "<h1>#{doc['title']}</h1>#{doc['description']}"
	}
end

doc = {"markers" => markers}

File.open("maps.json", "w") do |f|
	f.write(doc.to_json)
end


# {"_id"=>"f0c029309d3df81588bc9b9eeb0abc18", "_rev"=>"3-5ec99e412ac0bdba744aab321952c361", "rmt"=>"179", "latitude"=>42.361712, "longitude"=>-71.05221, "markername"=>"yellow", "title"=>"Our Shore - Ah Sure", "artist"=>"", "description"=>"", "discipline"=>"", "location_description"=>"Corner of Atlantic Ave. and Richmond St.", "full_address"=>"Corner of Atlantic Ave. and Richmond St., Boston, MA", "geometry"=>{"type"=>"Point", "coordinates"=>[-71.05221, 42.361712]}, "image_urls"=>[], "data_source"=>"Boston Art Commission", "doc_type"=>"artwork", "collection"=>"", "funders"=>"", "medium"=>"", "neighborhood"=>"", "year"=>""}
