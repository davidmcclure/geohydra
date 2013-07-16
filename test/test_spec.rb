$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.expand_path(File.dirname(__FILE__) + '/../config/boot')

require 'rubygems'
require 'rspec'
require 'awesome_print'

require 'geomdtk'

class ContentMetadataDS_Stub < Dor::ContentMetadataDS
  def save
    puts "Skipping save..."
  end
end

describe GeoMDTK do
  it "does something" do
    ds = ContentMetadataDS_Stub.from_xml('<contentMetadata/>')
    ap ds
    ap ds.ng_xml
    
    file={}
    file[:name]='new_file.jp2'
    file[:shelve]='no'
    file[:publish]='no'
    file[:preserve]='no'
    
    ds.add_resource([file], 'resource', 1)
    ap ds
    ap ds.ng_xml
  end
end