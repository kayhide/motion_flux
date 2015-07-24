require 'simplecov'
require 'simplecov-gem-profile'
SimpleCov.start 'gem'

ENV['RUBYMOTION_ENV'] ||= 'test'
require 'pry'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'motion_flux'
