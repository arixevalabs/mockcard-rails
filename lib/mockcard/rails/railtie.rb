# frozen_string_literal: true

# Wires MockCard into Rails: `config.mockcard.webhook_paths` enables the probe guard for those paths,
# and the probe secret / API key come from `config.mockcard`, Rails credentials (`mockcard:`) or ENV.
#
# Author: Arixeva Labs <hello@arixevalabs.com>
require "active_support/ordered_options"

module MockCard
  module Rails
    class Railtie < ::Rails::Railtie
      config.mockcard = ActiveSupport::OrderedOptions.new
      config.mockcard.webhook_paths = []

      initializer "mockcard.probe_guard" do |app|
        paths = app.config.mockcard.webhook_paths
        next if paths.empty?

        secret = -> { app.config.mockcard.probe_secret || app.credentials.dig(:mockcard, :probe_secret) || ENV["MOCKCARD_PROBE_SECRET"] }
        app.middleware.insert_before 0, MockCard::Rails::ProbeGuard, probe_secret: secret, paths: paths
      end

      initializer "mockcard.api_key" do |app|
        key = app.config.mockcard.api_key || app.credentials.dig(:mockcard, :api_key)
        ENV["MOCKCARD_API_KEY"] ||= key if key
      end
    end
  end
end
