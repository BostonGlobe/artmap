require 'rubygems'
require 'mongo'
require 'sinatra'
require 'json'

require "sinatra/reloader" if development?

set :public_folder, File.dirname(__FILE__)

get '/hi' do 
	"Hello world!"
end

get '/near' do
	content_type :json

	@uri = URI.parse(ENV['MONGOLAB_URI'])
	@conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
	@db   = @conn.db(uri.path.gsub(/^\//, ''))
	@coll = @db['boston_public_art']

	@lat = params[:lat].to_f
	@lon = params[:lon].to_f

	return_array = []

	geo_result = @db.command({'geoNear' => 'boston_public_art', 'near' => [@lon, @lat], 'spherical' => true, 'num' => 10})
	geo_result['results'].each do |r|
		return_array << r
	end

	# return the hash
	return_array.to_json
end

# {"dis"=>0.559295031048304, "obj"=>{"_id"=>BSON::ObjectId('4fb5b5881a86823ac0000074'), "rmt"=>"150", "latitude"=>42.383088, "longitude"=>-71.029731, "markername"=>"orange", "title"=>"Condor Street Urban Wild", "artist"=>"Kokoro Carvers and B. Amore", "description"=>"Not long ago, the land that now forms this 4.5-acre park was closed to the public. Years of industrial use had contaminated the soil and attracted illegal dumpers.  Chelsea Creek—the site of the Revolutionary War’s first naval battle—had long ago become a major waterway, attracting heavy industry to its shores and hastening the destruction of the area’s natural marshes.In the late ‘90s, the East Boston Chelsea Creek Action Group and the Boston Parks Department joined forces to transform this public hazard into a public park. Boston-born artist B. Amore was chosen to design a work of art, and, looking to weave her artistic contribution into the overall design of the park, Amore opted to recycle natural materials recovered from the site. The large stones that form her sculpture were originally part of an old seawall. Arranged in the shape of a boat, they evoke East Boston’s connection to the water, as well as its maritime industry. In 2007, six decorative steel fence panels by East Boston resident Leigh Hall were added to the parkland alongside Chelsea Creek. With a recreated salt marsh and native plants flourishing nearby, both Amore’s and Hall’s artworks point to a healthier relationship between humans and the marine resources we use.", "discipline"=>"Sculpture", "location_description"=>"300 Condor St.", "full_address"=>"300 Condor St., Boston, MA", "image_urls"=>["http://www.publicartboston.com/sites/default/files/node_images/Condor%20Street%20Park%20Chelsea%20Creek%20Clipper.jpg", "http://www.publicartboston.com/sites/default/files/node_images/Condor%20Street%202.jpg"], "data_source"=>"Boston Art Commission", "doc_type"=>"artwork", "collection"=>"City of Boston", "funders"=>"Browne Fund", "medium"=>"Quarry stone", "neighborhood"=>"East Boston", "year"=>"2003", "geo"=>{"lon"=>-71.029731, "lat"=>42.383088}}} 
