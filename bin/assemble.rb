#!/usr/bin/env ruby
require File.expand_path(File.dirname(__FILE__) + '/../config/boot')
require 'druid-tools'

TMPDIR = Dor::Config.geomdtk.tmpdir || 'tmp'
WORKDIR = Dor::Config.geomdtk.workspace || 'workspace'
STAGEDIR = Dor::Config.geomdtk.stage || 'stage'

def do_system cmd
  if cmd.is_a? Array
    cmd = cmd.join(' ')
  end
  puts "RUNNING: #{cmd}"
  system(cmd.to_s)
end

def main(workdir = WORKDIR, tmpdir = TMPDIR, stagedir = STAGEDIR)
  client = GeoMDTK::GeoNetwork.new
  client.each do |uuid|
    puts "Processing #{uuid}"
    obj = client.fetch(uuid)
    unless obj.druid
      # raise ArgumentError, "uuid #{uuid} missing druid"
      $stderr.puts "WARNING: uuid #{uuid} is missing Druid"
      next
    end
    
    # setup
    druid = DruidTools::Druid.new(obj.druid, workdir)
    raise ArgumentError unless DruidTools::Druid.valid?(druid.druid)
    [druid.path, druid.content_dir, druid.metadata_dir].each do |d|
      unless File.directory? d
        ap "Creating directory #{d}"
        FileUtils.mkdir_p d 
      end
    end

    # export MEF -- the .iso19139.xml file is preferred
    puts "Exporting MEF for #{uuid}"
    client.export(uuid, tmpdir)
    do_system(['unzip', '-jo', "#{tmpdir}/#{uuid}.mef", "#{uuid}/metadata/metadata*.xml", "-d", tmpdir])
    found_metadata = false
    %w{metadata.iso19139.xml metadata.xml}.each do |fn|
      fn = File.join(tmpdir, fn)
      next unless File.exist? fn
      found_metadata = true
      xfn = File.join(druid.metadata_dir, 'geoMetadata.xml')
      puts "Copying #{fn} => #{xfn}"
      FileUtils.copy_file fn, xfn
      File.delete fn

      yfn = File.join(druid.metadata_dir, 'descMetadata.xml')
      xslt = File.expand_path(File.dirname(__FILE__) + '/../lib/geomdtk/iso2mods.xsl')
      puts "Transforming[#{xslt}] #{xfn} => #{yfn}"
      do_system(['xsltproc', '--output', yfn, xslt, xfn])
      break
    end
    raise ArgumentError, "Cannot export MEF metadata: #{uuid}: Missing #{tmpdir}/metadata.xml" unless found_metadata
    
    # export content
    Dir.glob(File.join(stagedir, "#{druid.id}.zip")) do |fn|
      do_system(["unzip", "-jo", fn, "-d", druid.content_dir])
      Dir.glob("#{druid.content_dir}/*.shp") do |shp|
        ap shp
        k = File.basename(shp, '.shp')
        ap k
        fns = Dir.glob("#{druid.content_dir}/#{k}.*")
        ap fns
        ap fns.class
        fns = fns.delete_if {|x| x =~ %r{\.zip$}}
        ap fns
        do_system(["zip", "-1vDj", "#{druid.content_dir}/#{k}.zip", fns.join(' ')])
        fns.each {|f| File.delete(f) }
      end
    end    
  end
end

File.umask(002)
main