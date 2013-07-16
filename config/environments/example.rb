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
    
    postgis do
      host '127.0.0.1'
      port '5432'
      user 'postgres'
      password nil
      database 'postgres'
      schema 'public'
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
  
  content do
    content_user 'myuser'
    content_base_dir '/my/content'
    content_server 'my.content.host'
    ssh_auth 'gssapi-with-mic'
  end
  
  stacks do
    document_cache_storage_root '/my/document/cache'
    document_cache_host 'my.document.cache.host'
    document_cache_user 'my.document.cache.user'
    local_workspace_root '/my/local/workspace'
    storage_root '/my/remote/stacks'
    host 'my.stacks.host'
    user 'my.stacks.user'
    ssh_auth 'gssapi-with-mic'
  end
end

GeoMDTK::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
end
