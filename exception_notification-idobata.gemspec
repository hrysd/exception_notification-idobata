lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exception_notification/idobata/version'

Gem::Specification.new do |gem|
  gem.name          = 'exception_notification-idobata'
  gem.version       = ExceptionNotification::Idobata::VERSION
  gem.authors       = ['Hiroshi Yoshida']
  gem.email         = ['hrysd22@gmail.com']
  gem.summary       = %q{exception_notification for Idobata}
  gem.description   = %q{exception_notification for Idobata}
  gem.homepage      = 'https://github.com/hrysd/exception_notification-idobata'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'exception_notification', '~> 4.0.0'

  gem.add_development_dependency 'bundler', '~> 1.5'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.0.0'
end
