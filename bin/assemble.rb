#!/usr/bin/env ruby
# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../config/boot')
require 'druid-tools'
require 'optparse'

def setup_druid(obj, flags)
  druid = DruidTools::Druid.new(obj.druid, flags[:workspacedir])
  raise ArgumentError unless DruidTools::Druid.valid?(druid.druid)
  %w{path content_dir metadata_dir temp_dir}.each do |k|
    d = druid.send(k.to_sym)
    unless File.directory? d
      $stderr.puts "Creating directory #{d}" if flags[:verbose]
      FileUtils.mkdir_p d
    end
  end
  druid
end

def find_mef(druid, uuid, flags)
  # export MEF -- the .iso19139.xml file is preferred
  puts "Exporting MEF for #{uuid}" if flags[:verbose]
  client.export(uuid, flags[:tmpdir])
  system(['unzip', '-oq',
          "'#{flags[:tmpdir]}/#{uuid}.mef'",
          '-d', "'#{flags[:tmpdir]}'"].join(' '))
  found_metadata = false
  %w{metadata.iso19139.xml metadata.xml}.each do |fn| # priority order
    unless found_metadata
      fn = File.join(flags[:tmpdir], uuid, 'metadata', fn)
      next unless File.exist? fn

      found_metadata = true
      # original ISO 19139
      ifn = File.join(druid.temp_dir, 'iso19139.xml')
      FileUtils.install fn, ifn, :verbose => flags[:verbose]
    end
  end
  ifn
end

def find_local(druid, xml, flags)
  ifn = File.join(druid.temp_dir, 'iso19139.xml')
  unless File.exist?(ifn)
    File.open(ifn, "w") {|f| f << xml.to_s}
  end
  ifn
end

def convert_iso2geo(druid, ifn, flags)
  # GeoMetadataDS
  gfn = File.join(druid.metadata_dir, 'geoMetadata.xml')
  puts "Generating #{gfn}" if flags[:verbose]
  File.open(gfn, 'w') { |f| f << GeoMDTK::Transform.to_geoMetadataDS(ifn, { :purl => "http://purl/#{druid.id}" }) }
  gfn
end

def convert_geo2mods(druid, geoMetadata, flags)
  # MODS from GeoMetadataDS
  ap({:geoMetadata => geoMetadata.ng_xml, :descMetadata => geoMetadata.to_mods}) if flags[:debug]
  dfn = File.join(druid.metadata_dir, 'descMetadata.xml')
  puts "Generating #{dfn}" if flags[:verbose]
  File.open(dfn, 'w') { |f| f << geoMetadata.to_mods.to_xml }
  dfn
end

def convert_geo2solr(druid, geoMetadata, flags)
  # Solr document from GeoMetadataDS
  sfn = File.join(druid.temp_dir, 'solr.xml')
  puts "Generating #{sfn}" if flags[:verbose]
  h = geoMetadata.to_solr_spatial
  ap({:to_solr_spatial => h}) if flags[:debug]
  
  doc = Nokogiri::XML::Builder.new do |xml|
    xml.add {
      xml.doc_ {
        h.each do |k, v|
          v.each do |s|
            xml.field s, :name => k
          end unless v.nil?
        end unless h.nil?
      }
    }
  end
  File.open(sfn, 'w') { |f| f << doc.to_xml }
  sfn
end

def convert_mods2ogpsolr(druid, dfn, flags)
  geoserver = flags[:geoserver]
  stacks = flags[:stacks]
  purl = "#{flags[:purl]}/#{druid.id}"
  # OGP Solr document from GeoMetadataDS
  sfn = File.join(druid.temp_dir, 'ogpSolr.xml')
  FileUtils.rm_f(sfn) if File.exist?(sfn)
  cmd = ['xsltproc',
          "--stringparam geometryType #{geometryType}",
          "--stringparam geoserver #{geoserver}",
          "--stringparam stacks #{stacks}",
          "--stringparam purl #{purl}",
          "--stringparam druid #{druid.id}",
          "--output '#{sfn}'",
          "'#{File.expand_path(File.dirname(__FILE__) + '/../lib/geomdtk/mods2ogp.xsl')}'",
          "'#{dfn}'"
          ].join(' ')
  puts "Generating #{sfn} using #{cmd}" if flags[:verbose]
  ap({:cmd => cmd}) if flags[:debug]
  system(cmd)
  
  # post-process to resolve XInclude
  doc = Nokogiri::XML::Document.parse(open(sfn), nil, nil, Nokogiri::XML::ParseOptions::XINCLUDE)
  ap({:root => doc.root.name, :root_namespaces => doc.root.namespaces}) if flags[:debug]
  File.open(sfn, 'w') { |f| f << doc.to_xml }
  
  # cleanup by adding CDATA
  cmd = ['xsltproc',
          "--output '#{sfn}'",
          "'#{File.expand_path(File.dirname(__FILE__) + '/../lib/geomdtk/ogpcleanup.xsl')}'",
          "'#{sfn}'"  
          ].join(' ')
  puts "Generating #{sfn} using #{cmd}" if flags[:verbose]
  ap({:cmd => cmd}) if flags[:debug]
  system(cmd)
  
  sfn
end

def convert_geo2dc(geoMetadata, flags)
  # Solr document from GeoMetadataDS
  dcfn = File.join(druid.temp_dir, 'dc.xml')
  puts "Generating #{dcfn}" if flags[:verbose]
  File.open(dcfn, 'w') { |f| f << geoMetadata.to_dublin_core.to_xml }
  dcfn
end

def export_images(druid, uuid, flags)
  # export any thumbnail images
  %w{png jpg}.each do |fmt|
    Dir.glob("#{flags[:tmpdir]}/#{uuid}/{private,public}/*.#{fmt}") do |fn|
      ext = '.' + fmt
      tfn = File.basename(fn, ext)
      # convert _s to _small as per GeoNetwork convention
      tfn = tfn.gsub(/_s$/, '_small')
      imagefn = File.join(druid.content_dir, tfn + ext)
      FileUtils.install fn, imagefn, 
                        :verbose => flags[:debug]
      yield imagefn if block_given?
    end
  end
end

def export_zip(druid, flags)
  # export content into zip files
  Dir.glob(File.join(flags[:stagedir], "#{druid.id}.zip")) do |fn|
    # extract shapefile name using filename pattern from
    # http://www.esri.com/library/whitepapers/pdfs/shapefile.pdf
    k = %r{([a-zA-Z0-9_-]+)\.(shp|tif)$}i.match(`unzip -l #{fn}`)[1]
    ofn = "#{druid.content_dir}/#{k}.zip"
    FileUtils.install fn, ofn, :verbose => flags[:verbose]
    yield ofn if block_given?
  end
end

def doit(client, uuid, obj, flags)
  druid = setup_druid(obj, flags)

  if flags[:geonetwork]
    ifn = find_mef(druid, uuid, flags)
  else
    raise ArgumentError, druid if obj.content.empty?
    ifn = find_local(druid, obj.content.to_s, flags)
  end
  
  puts "Processing #{ifn}"
  gfn = convert_iso2geo(druid, ifn, flags)
  geoMetadata = Dor::GeoMetadataDS.from_xml File.read(gfn)
  dfn = convert_geo2mods(druid, geoMetadata, flags)
  sfn = convert_geo2solr(druid, geoMetadata, flags)
  ofn = convert_mods2ogpsolr(druid, dfn, flags)
  if flags[:geonetwork]
    export_images(druid, uuid, flags)
  end
  export_zip(druid, flags)
end

def main(flags)
  File.umask(002)
  if flags[:geonetwork]
    client = GeoMDTK::GeoNetwork.new
    client.each do |uuid|
      begin
        puts "Processing #{uuid}"
        obj = client.fetch(uuid)
        doit client, uuid, obj, flags
      rescue Exception => e
        $stderr.puts e
        $stderr.puts e.backtrace if flags[:debug]
      end
    end
  else
    Dir.glob(flags[:stagedir] + '/' + DruidTools::Druid.glob + '.zip') do |zipfn|
      obj = Struct.new(:content, :status, :druid).new(File.read(zipfn.gsub('.zip', '.xml')), nil, File.basename(zipfn, '.zip'))      
      ap({:zipfn => zipfn, :obj => obj})
      doit client, nil, obj, flags
    end
  end
end

# __MAIN__
begin
  flags = {
    :debug => false,
    :verbose => false,
    :geonetwork => false,
    :geoserver => GeoMDTK::Config.ogp.geoserver,
    :stacks => GeoMDTK::Config.ogp.stacks,
    :solr => GeoMDTK::Config.ogp.solr,
    :purl => GeoMDTK::Config.ogp.purl,
    :stagedir => GeoMDTK::Config.geomdtk.stage || 'stage',
    :workspacedir => GeoMDTK::Config.geomdtk.workspace || 'workspace',
    :tmpdir => GeoMDTK::Config.geomdtk.tmpdir || 'tmp'
  }

  OptionParser.new do |opts|
    opts.banner = <<EOM
Usage: #{File.basename(__FILE__)} [options]
EOM
    opts.on("--geonetwork", "Run against GeoNetwork metadata") do |v|
      flags[:geonetwork] = v
    end
    opts.on("-v", "--verbose", "Run verbosely") do |v|
      flags[:debug] = true if flags[:verbose]
      flags[:verbose] = true
    end
    opts.on("--stagedir DIR", "Staging directory with ZIP files (default: #{flags[:stagedir]})") do |v|
      flags[:stagedir] = v
    end
    opts.on("--workspace DIR", "Workspace directory for assembly (default: #{flags[:workspacedir]})") do |v|
      flags[:workspacedir] = v
    end
    opts.on("--tmpdir DIR", "Temporary directory for assembly (default: #{flags[:tmpdir]})") do |v|
      flags[:tmpdir] = v
    end
  end.parse!

  %w{tmpdir stagedir workspacedir}.each do |k|
    d = flags[k.to_sym]
    raise ArgumentError, "Missing directory #{d}" unless d.nil? or File.directory? d
  end

  main flags
rescue SystemCallError => e
  $stderr.puts "ERROR: #{e.message}"
  exit(-1)
end
