require 'rubygems'
require 'sequel'

# replace with DB connection to appropriate place
DB = Sequel.sqlite

DB.create_table :locations do
  primary_key :id
	column :zip, :integer
  column :state, :string
  column :city, :string
  column :lat, :float
	column :lon, :float
end

zips = DB[:locations]

# download from http://www.census.gov/geo/www/gazetteer/places2k.html
zips_file = File.new("zcta5.txt", "r")

zips_file.each_line { |l|
  state = l[0..1]

	# skip Puerto Rico
  next if state == 'PR'

  zip = l[2..6]
  lat = l[136..145].strip.to_f
  lon = l[146..157].strip.to_f

  zips << {:zip => zip, :state => state, :lat => lat, :lon => lon}
  puts zip
}

# download from http://www.census.gov/geo/www/gazetteer/places2k.html
locs_file = File.new("places2k.txt", "r")

locs_file.each_line { |l|
  state = l[0..1]

	# skip Puerto Rico
	next if state == 'PR'

	# remove 'city', etc. from end of locatian name
	name = l[9..72].strip.split.slice(0..-2).join(" ").strip
	lat = l[143..152].strip.to_f
	lon = l[153..163].strip.to_f

  zips << {:state => state, :city => name, :lat => lat, :lon => lon}
	puts "#{name}, #{state}: #{lat} #{lon}"
}


