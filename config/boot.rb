require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

ENV['GEOMDTK_ENVIRONMENT'] ||= 'development'
GEOMDTK_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'confstruct'
ENV_FILE = GEOMDTK_ROOT + "/config/environments/#{ENV['GEOMDTK_ENVIRONMENT']}"
require ENV_FILE

# Load the project and its dependencies.

require 'geomdtk'
