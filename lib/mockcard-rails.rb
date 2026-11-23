# frozen_string_literal: true

# MockCard for Rails. Author: Arixeva Labs <hello@arixevalabs.com>
require "mockcard"
require_relative "mockcard/rails/probe_guard"
require_relative "mockcard/rails/railtie" if defined?(Rails::Railtie)
