require 'rubygems'
require 'mongo'
require 'json'
require 'uri'

DATA_FILE = 'data/boston_public_art_refined.json'

boston_art_json = JSON.load(File.open(DATA_FILE))
docs = boston_art_json['docs']

puts "Loaded #{docs.length} records"

uri = URI.parse(ENV['MONGOLAB_URI'])
conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
db   = conn.db(uri.path.gsub(/^\//, ''))
coll = db['boston_public_art']

# make a spatial element so mongo can index on it
docs.map do |d|
	d['geo'] = {'lon' => d['longitude'], 'lat' => d['latitude']}
	d.delete("geometry")
	d.delete("_id")
	d.delete("_rev")
end


docs.each do |doc|
	coll.insert(doc)
end

puts "There are now #{coll.count} records in the collection."

# {"_id"=>"f0c029309d3df81588bc9b9eeb0abc18", "_rev"=>"3-5ec99e412ac0bdba744aab321952c361", "rmt"=>"179", "latitude"=>42.361712, "longitude"=>-71.05221, "markername"=>"yellow", "title"=>"Our Shore - Ah Sure", "artist"=>"", "description"=>"", "discipline"=>"", "location_description"=>"Corner of Atlantic Ave. and Richmond St.", "full_address"=>"Corner of Atlantic Ave. and Richmond St., Boston, MA", "geometry"=>{"type"=>"Point", "coordinates"=>[-71.05221, 42.361712]}, "image_urls"=>[], "data_source"=>"Boston Art Commission", "doc_type"=>"artwork", "collection"=>"", "funders"=>"", "medium"=>"", "neighborhood"=>"", "year"=>""}
