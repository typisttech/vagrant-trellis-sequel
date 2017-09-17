# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant_plugins/trellis_sequel/identity.rb'

Gem::Specification.new do |spec|
  spec.name          = VagrantPlugins::TrellisSequel::Identity.name
  spec.version       = VagrantPlugins::TrellisSequel::Identity.version
  spec.authors       = ['Tang Rufus', 'Typist Tech']
  spec.email         = ['tangrufus@gmail.com', 'vagrant-trellis-sequel@typist.tech']

  spec.summary       = VagrantPlugins::TrellisSequel::Identity.summary
  spec.homepage      = 'https://www.typist.tech/projects/vagrant-trellis-sequel'
  spec.license       = 'MIT'

  spec.required_ruby_version = '~> 2.3'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'ansible-vault', '~> 0.2.1'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rubocop', '~> 0.49'
end
