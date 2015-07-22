
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rerake/version'

Gem::Specification.new do |spec|
  spec.name          = "rerake"
  spec.version       = Rerake::VERSION
  spec.authors       = ["Jeff Dickey"]
  spec.email         = ["jdickey@seven-sigma.com"]

  spec.summary       = %q{Summarises the result of running `rake` on your project.}
  spec.description   = %Q{Summarises the result of running various tools commonly run as part of the default `rake` task for a Ruby (particularly Rails) application. These tools include:\n* MiniTest (Spec or Unit)\n* SimpleCov\n* Flay\n* Flog\n* Reek\n* Cane}
  spec.homepage      = "https://github.com/jdickey/rerake"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.2.0'
  spec.required_rubygems_version = '>= 2.4.8'
  spec.cert_chain = ['certs/jdickey.pem']
  spec.signing_key = File.expand_path("~/.ssh/gem-private_key_jdickey.pem") if $0 =~ /gem\z/

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.7"
end
