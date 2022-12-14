# frozen_string_literal: true

require 'English'

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'public_uid/version'

Gem::Specification.new do |spec|
  spec.name          = 'public_uid'
  spec.version       = PublicUid::VERSION
  spec.authors       = ['Tomas Valent']
  spec.email         = ['equivalent@eq8.eu']
  spec.description   = 'Automatic generates public unique identifier for model'
  spec.summary       = 'Automatic generates public UID column'
  spec.homepage      = 'https://github.com/equivalent/public_uid'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '> 4.2' # ensures compatibility for ruby 2.0.0+ to head
  spec.add_dependency 'nanoid', '~> 2.0'
  spec.add_development_dependency 'activesupport', '> 4.2'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest', '~> 5'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rr', '~> 1.1.2'
  spec.add_development_dependency 'sqlite3', '~> 1.4.1'
end
