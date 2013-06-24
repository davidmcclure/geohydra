module GeoMDTK
  Config = Confstruct::Configuration.new do
    geomdtk do
      workspace "/var/geomdtk/current/workspace"
      stage "/var/geomdtk/current/stage"
    end

    geonetwork do
      service_root 'http://host/geonetwork'
    end
    
    geoserver do
      workspace 'druid'
      namespace 'http://mynamespace'
    end

    geowebcache do
      seed do # one or more seeding options
        basic do
          gridSetId 'EPSG:4326' # required
          zoom '1:10' # required
          tileFormat 'image/png' # optional, defaults to image/png
          threadCount 2 # optional, defaults to 1
        end
        google_toponly do
          gridSetId 'EPSG:900913'
          zoom '1:3'
        end
      end
    end 
  end
end

require 'dor-services'
Dor::Config.configure do
  dor do
    service_root 'http://user:mypassword@host'
    num_attempts  1
    sleep_time   1
  end

  fedora do 
    url 'https://user:mypassowrd@host/fedora'
  end
  
  gsearch do
    url 'http://user:mypassword@host/solr'
  end

  solrizer do
    url 'http://user:mypassword@host/solr'
  end
  
  ssl do
    cert_file File.join(File.dirname(__FILE__) + '/../certs', "my.crt")
    key_file  File.join(File.dirname(__FILE__) + '/../certs', "my.key")
    key_pass ''
  end

  suri do
    mint_ids true
    id_namespace 'druid'
    url 'http://host'
    user 'myuser'
    pass 'mypassword'
  end
  
  workflow do
    url 'http://user:mypassword@host/workflow/'
  end
  
end
