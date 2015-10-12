# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heroku_builder/version'

Gem::Specification.new do |spec|
  spec.name          = 'heroku_builder'
  spec.version       = HerokuBuilder::VERSION
  spec.authors       = ['Jason Vanderhoof']
  spec.email         = ['jvanderhoof (at) google mail']

  spec.summary       = %q{Add the ability to generate multiple heroku application environments and configurations.}
  spec.description   = %q{Add the ability to generate multiple heroku application environments and configurations.}
  spec.homepage      = 'https://github.com/jvanderhoof/heroku_builder.'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://rubygems.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'platform-api'
  spec.add_runtime_dependency 'hashdiff'
  spec.add_runtime_dependency 'git'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
