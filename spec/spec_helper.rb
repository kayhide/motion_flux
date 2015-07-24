require 'simplecov'
require 'simplecov-gem-profile'
SimpleCov.start 'gem'

require 'pry'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'motion_flux'
