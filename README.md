GeoHydra
=======

Geospatial MetaData ToolKit for use as a Geo[Hydra](http://projecthydra.org) head.
head.

Setup
-----

Core requirements, with versions as-tested:

  * ArcGIS 10.2
  * GeoNetwork 2.8 (optional for metadata management)
  * GEOS 3.3
  * GeoServer 2.2
  * OpenGeoPortal 1.2
  * PostGIS 2.0
  * PostgreSQL 9.2
  * Red Hat Enterprise Linux Server release 6.4 (Santiago)
  * Ruby 1.9

If needed, configure host to use Ruby 1.9.3:

    % rvm_path=$HOME/.rvm rvm-installer --auto-dotfiles
    % source $HOME/.bashrc
    % cd geohydra
    % rvm use 1.9.3@geohydra --create
    % rvm rvmrc create

To install the native extensions to Ruby pg:

    # yum install postgresql92-devel
    % gem install pg -- --with-pg_config=/usr/pgsql-9.2/bin/pg_config 

You need to customize your configuration parameters like so:

    % $EDITOR config/environments/development.rb

Run setup:

    % bundle install
    % bundle exec rake spec
    % bundle exec rake yard

Utilities
---------

To ingest ArcGIS `*.shp.xml` files and transform into ISO 19139 files

    % bundle exec bin/ingest_arcgis.rb /var/geohydra/current/upload/druid

To package up the .shp files into .zip files:

    % bundle exec bin/assemble_data.rb /var/geohydra/current/upload/druid

To assemble the workspace, populate the *geohydra.stage* directory with `druid` directories which
contain the data as described in the Data Wrangling section below.

    % bundle exec bin/assemble.rb

To project all Shapefiles into EPSG:4326 (WGS84), as needed:

    % bundle exec bin/derive_wgs84.rb

To upload the druid metadata to DOR:

    % bundle exec bin/accession.rb druid1 [druid2 druid3...]

To upload the druid packages to PostGIS, you will need `shp2pgsql` then use:

    % bundle exec bin/loader_postgis.rb druid1 [druid2 druid3...]

Then, login to GeoServer and import the data layers from PostGIS

    % bundle exec bin/sync_geoserver_metadata.rb

To upload the druid packages to GeoServer use OpenGeo's *Import Data* feature, or via the filesystem:

    % bundle exec bin/loader.rb druid1 [druid2 druid3...]

To upload the OpenGeoPortal Solr documents, use:

    % bundle exec bin/solr_indexer.rb 

Caveats
=======

To enable logging for the Rest client, use

    % RESTCLIENT_LOG=stdout bundle exec ...

These utilities assume a few things:

* `/var/geohydra/current` is the core root folder for data/metadata
* `upload` holds data to be processed
* `upload/druid` holds data and metadata in the druid workspace structure

Data Wrangling
==============

The file system structure will initially look like this (see [Consul
page](https://consul.stanford.edu/x/C5xSC) for a description.). The `geoOptions.json` contain meta-metadata about the package:

    { 
      "druid"        : "zz943vx1492", 
      "geometryType" : "Point" 
    }

Note that you can use `scripts/build.rb` to help build out a `druid/` folder with data for upload
if you don't already have the below structure ready.

    zv925hd6723/
      metadata/
      content/
      temp/
        geoOptions.json
        OGWELLS.dbf
        OGWELLS.prj
        OGWELLS.sbn
        OGWELLS.sbx
        OGWELLS.shp
        OGWELLS.shp.xml
        OGWELLS.shx

after assembling the data, it should look like this, where the temp files for the shapefiles are all
symlinks to reduce space requirements:

    zv925hd6723/
      metadata/
      content/
        data.zip
        preview.jpg
      temp/
        geoOptions.json
        OGWELLS-iso19139-fc.shp.xml
        OGWELLS-iso19139.shp.xml
        OGWELLS.dbf
        OGWELLS.prj
        OGWELLS.sbn
        OGWELLS.sbx
        OGWELLS.shp
        OGWELLS.shp.xml
        OGWELLS.shx


then at the end of processing -- prior to accessioning -- it will look like in your workspace:

    zv925hd6723/
      metadata/
        contentMetadata.xml
        descMetadata.xml
        geoMetadata.xml
      content/
        data.zip
        data_ESRI_4326.zip (optionally)
        preview.jpg
      temp/
        dc.xml
        geoOptions.json
        iso19139.xml
        ogpSolr.xml
        solr.xml

To continue with accessioning, stage the data as follows:

    zv925hd6723.xml -> iso19139.xml
    zv925hd6723.zip -> data.zip
    zv925hd6723.jpg -> preview.jpg
    zv925hd6723.json -> geoOptions.json

Credits
=======

Author:  
Darren Hardy <drh@stanford.edu>,  
Digital Library Systems and Services,  
Stanford University Libraries

