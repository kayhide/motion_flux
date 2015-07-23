# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'motion_flux/version'

Gem::Specification.new do |spec|
  spec.name          = 'motion_flux'
  spec.version       = MotionFlux::VERSION
  spec.authors       = ['kayhide']
  spec.email         = ['kayhide@gmail.com']
  spec.summary       = 'MotionFlux supports to build Flux-based RubyMotion apps.'
  spec.description   = 'MotionFlux supports to build Flux-based RubyMotion apps.'
  spec.homepage      = 'https://github.com/kayhide/motion_flux'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
