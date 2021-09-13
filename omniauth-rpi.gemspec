
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-rpi/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-rpi'
  spec.version       = OmniAuth::Rpi::VERSION
  spec.author        = 'Raspberry Pi Foundation'
  spec.email         = 'web@raspberrypi.org'

  spec.summary       = 'Official OmniAuth strategy for Raspberry Pi.'
  spec.description   = 'Supporting OmniAuth OAuth 2 authentication for Raspberry Pi accounts.'
  spec.license       = 'MIT'
  spec.homepage      = 'https://www.raspberrypi.org'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.add_runtime_dependency 'jwt', '~> 2.2.3'
  spec.add_runtime_dependency 'omniauth', '~> 2.0'
  spec.add_runtime_dependency 'omniauth-oauth2', '~> 1.4'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.20'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.4.0'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
end
