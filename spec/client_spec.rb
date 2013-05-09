$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require File.expand_path(File.dirname(__FILE__) + '/../config/boot')

require 'bundler/setup'
require 'rspec'
# require 'awesome_print'
require 'rspec/autorun'
require 'rspec/mocks'

require 'rubygems'
require 'geomdtk'
require 'pp'

describe GeoMDTK::Client do

  describe "#fetch_by_uuid" do

    it "verify identificationInfo" do
      ['ad78de38-212e-4131-856d-22719145d5dc'].each do |uuid|
        doc = GeoMDTK::Client.fetch_by_uuid(uuid).content
        doc.xpath('/gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString/text()').to_s.should == uuid
        title = doc.xpath("/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/" + 
                  "gmd:citation/gmd:CI_Citation/" + 
                  "gmd:title/gco:CharacterString").text
        title.should == "Carbon Dioxide (CO2) Pipelines in the United States, 2011"
        
        # puts doc.to_xml(:indent => 2, :encoding => 'UTF-8')
      end
    end
  end
end
