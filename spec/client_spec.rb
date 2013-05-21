$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require File.expand_path(File.dirname(__FILE__) + '/../config/boot')

require 'bundler/setup'
require 'rspec'
require 'rspec/autorun'
require 'rspec/mocks'

require 'rubygems'
require 'geomdtk'
require 'awesome_print'

describe GeoMDTK::Client do

  describe "#fetch_by_uuid" do

    it "verify identificationInfo" do
      %w{FA6ED959-7DED-4722-B1FB-A85FB79725BA}.each do |uuid|
        begin
          doc = GeoMDTK::Client.fetch_by_uuid(uuid).content
          fileId = doc.xpath('/gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString/text()')
          fileId.to_s.should == uuid
          title = doc.xpath("/gmd:MD_Metadata/" + 
                    "gmd:identificationInfo/gmd:MD_DataIdentification/" + 
                    "gmd:citation/gmd:CI_Citation/" + 
                    "gmd:title/gco:CharacterString").text
          title.should == "Carbon Dioxide (CO2) Pipelines in the United States, 2011"
        rescue RestClient::Forbidden => e
          ap e
        end
        
      end
    end
    
    it "info" do
      r = GeoMDTK::Client.info(['site', 'users', 'groups', 'sources', 'operations'])
      r.keys.size.should == 5
    end
    
    it "info groups" do
      GeoMDTK::Client.info(['groups']).each do |k, v|
        v.xpath('/info/groups/group').size.should > 0
        v.xpath('/info/groups/group/name/text()="all"').should == true
        g = v.xpath('/info/groups/group[./name/text()="all"]').first
        g['id'].to_i.should == 1
      end
    end
    
    it "info bad parameter" do
      expect { GeoMDTK::Client.info(%w{nonsense}) }.to raise_error(ArgumentError)
      expect { GeoMDTK::Client.info(%w{site groups nonsense}) }.to raise_error(ArgumentError)
    end
    
    it "search #each_uuid" do
      GeoMDTK::Client.each_uuid do |uuid|
        # ap uuid
      end
    end
  end
end
