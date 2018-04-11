lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kpn_winrm/version'

Gem::Specification.new do |spec|
  spec.name          = 'kpn_winrm'
  spec.version       = KpnWinrm::VERSION
  spec.authors       = ['kpn']
  spec.email         = ['noreply@kpn.com']

  spec.summary       = 'Additional functions for acceptance testing, to run commands and puppet apply over WinRM instead of ssh'
  spec.homepage      = 'https://github.com/kpn-puppet/gem-kpn-winrm'
  spec.license       = 'Apache-2.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://rubygems.org.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'winrm', '~> 2.2', '>= 2.2.2'
  spec.add_dependency 'winrm-elevated', '~> 1.1', '>= 1.1.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
