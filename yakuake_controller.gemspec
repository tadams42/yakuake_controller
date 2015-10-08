# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yakuake_controller/version'

Gem::Specification.new do |spec|

  spec.name          = 'yakuake_controller'
  spec.version       = YakuakeController::VERSION

  spec.required_ruby_version = '~> 2.0'

  spec.authors       = ['Tomislav Adamic']
  spec.email         = ['tomislav.adamic@gmail.com']
  spec.summary       = %q{Client for Yakuake DBus interface.}
  spec.description   = %q{Client for Yakuake DBus interface.}
  # spec.homepage      = 'TODO - enter homepage'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'ruby-dbus', '~> 0.11'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3'

  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'pry-doc', '~> 0.8'
  spec.add_development_dependency 'minitest', '~> 5.4'
  spec.add_development_dependency 'minitest-reporters', '~> 1.0'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'mocha', '~> 1.1'

  spec.add_development_dependency 'activesupport', '~> 4.1'

end
