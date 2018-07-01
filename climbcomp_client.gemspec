# frozen_string_literal: true

# lib = File.expand_path("../lib", __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
# require "climbcomp_client/version"

Gem::Specification.new do |spec|
  spec.name          = 'climbcomp_client'
  spec.license       = 'MIT'
  # spec.version       = ClimbcompClient::VERSION
  spec.version       = '0.1.0'
  spec.authors       = ['Skip Baney']
  spec.email         = ['twelvelabs@gmail.com']

  spec.summary       = 'Ruby client for the climbcomp service'
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = 'https://github.com/twelvelabs/climbcomp_client'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # spec.files         = `git ls-files -z`.split("\x0").reject do |f|
  #  f.match(%r{^(test|spec|features)/})
  # end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4.0.0'
  spec.add_dependency 'faraday', '~> 0.12'
  spec.add_dependency 'faraday_middleware', '~> 0.12'
  spec.add_dependency 'launchy', '~> 2.4.3'
  spec.add_dependency 'oauth2', '~> 1.4'
  spec.add_dependency 'pastel', '~> 0.7.2'
  spec.add_dependency 'thor', '~> 0.20.0'
  spec.add_dependency 'tty-color', '~> 0.4.2'
  spec.add_dependency 'tty-command', '~> 0.8.0'
  spec.add_dependency 'tty-config', '~> 0.2.0'
  spec.add_dependency 'tty-cursor', '~> 0.5.0'
  spec.add_dependency 'tty-editor', '~> 0.4.0'
  spec.add_dependency 'tty-file', '~> 0.6.0'
  spec.add_dependency 'tty-font', '~> 0.2.0'
  spec.add_dependency 'tty-markdown', '~> 0.3.0'
  spec.add_dependency 'tty-pager', '~> 0.11.0'
  spec.add_dependency 'tty-platform', '~> 0.1.0'
  spec.add_dependency 'tty-progressbar', '~> 0.14.0'
  spec.add_dependency 'tty-prompt', '~> 0.16.1'
  spec.add_dependency 'tty-screen', '~> 0.6.4'
  spec.add_dependency 'tty-spinner', '~> 0.8.0'
  spec.add_dependency 'tty-table', '~> 0.10.0'
  spec.add_dependency 'tty-tree', '~> 0.1.0'
  spec.add_dependency 'tty-which', '~> 0.3.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters', '~> 1.3'
  spec.add_development_dependency 'mocha', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.57'
  spec.add_development_dependency 'webmock', '~> 3.4'
end
