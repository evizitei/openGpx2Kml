# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tf1_converter/version'

Gem::Specification.new do |gem|
  gem.name          = "open_gpx_2_kml"
  gem.version       = TF1Converter::VERSION
  gem.authors       = ["Ethan Vizitei"]
  gem.email         = ["ethan.vizitei@gmail.com"]
  gem.description   = %q{A GPX to KML converter for FEMA US&R}
  gem.summary       = %q{A GPX to KML converter for FEMA US&R}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake', '10.0.3'
  gem.add_development_dependency 'rspec', '2.12.0'
  gem.add_development_dependency 'pry', '0.9.11.4'
  gem.add_development_dependency 'timecop', '0.5.9.2'

  gem.add_dependency 'thor', '0.17.0'
  gem.add_dependency 'nokogiri', '1.5.6'
  gem.add_dependency 'builder', '3.1.4'
  gem.add_dependency 'geo_swap', '0.2.1'
  gem.add_dependency 'rubyzip', '0.9.9'
end
