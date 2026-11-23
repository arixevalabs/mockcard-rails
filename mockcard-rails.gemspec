# frozen_string_literal: true

# Gem specification for MockCard's Rails integration. Author: Arixeva Labs <hello@arixevalabs.com>
Gem::Specification.new do |s|
  s.name        = "mockcard-rails"
  s.version     = "2.0.0"
  s.summary     = "MockCard for Rails: probe-guard middleware, credentials integration and an install generator."
  s.authors     = ["Arixeva Labs"]
  s.email       = "hello@arixevalabs.com"
  s.homepage    = "https://www.mockcard.io"
  s.license     = "MIT"
  s.description = "Rails integration for MockCard: Rack middleware that answers MockCard's production monitoring probes safely, Rails credentials support and a rails g mockcard:install generator. Builds on the mockcard gem."
  s.metadata    = {
    "homepage_uri" => "https://www.mockcard.io",
    "documentation_uri" => "https://www.mockcard.io/docs",
    "source_code_uri" => "https://github.com/arixevalabs/mockcard-rails",
    "bug_tracker_uri" => "https://github.com/arixevalabs/mockcard-rails/issues",
    "rubygems_mfa_required" => "true"
  }
  s.files       = Dir["lib/**/*", "README.md", "LICENSE"]
  s.required_ruby_version = ">= 3.1"
  s.add_dependency "mockcard", "~> 2.0"
  s.add_dependency "railties", ">= 7.1"
end
