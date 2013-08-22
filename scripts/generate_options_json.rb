#!/usr/bin/env ruby

require 'geomdtk'
require 'json'

def doit(shp)
  r = {}
  r['druid'] = File.basename(File.dirname(File.dirname(shp)))
  raise ArgumentError unless GeoMDTK::Utils.shapefile?(shp)
  r['geometryType'] = GeoMDTK::Transform.geometry_type(shp)
  r['filename'] = File.basename(shp)
  File.open(File.join(File.dirname(shp), 'options.json'), 'w') do |f|
    f.puts r.to_json.to_s
  end
  
end

if ARGV.empty?
  Dir.glob('/var/geomdtk/current/upload/druid/**/*.shp') do |shp|
    doit(shp)
  end
else
  ARGV.each do |shp|
    doit(shp)
  end
  
end
