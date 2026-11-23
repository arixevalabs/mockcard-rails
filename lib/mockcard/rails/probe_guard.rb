# frozen_string_literal: true

# Rack middleware for payment webhook paths: answers verified MockCard production probes with
# 200 + "MockCard-Probe-Ack: skipped" before Rails routes the request. Forged probes pass through to
# your normal handling, so the header can never make your app process anything it otherwise wouldn't.
#
# Author: Arixeva Labs <hello@arixevalabs.com>
module MockCard
  module Rails
    class ProbeGuard
      # @param app [#call] The next Rack app.
      # @param probe_secret [String, #call] The probe secret, or a proc returning it (read lazily).
      # @param paths [Array<String>] Only requests to these path prefixes are checked.
      def initialize(app, probe_secret:, paths: ["/"])
        @app = app
        @probe_secret = probe_secret
        @paths = paths
      end

      # @param env [Hash] The Rack env.
      # @return [Array] The probe acknowledgement, or the next app's response.
      def call(env)
        return @app.call(env) unless env["REQUEST_METHOD"] == "POST" && @paths.any? { |p| env["PATH_INFO"].to_s.start_with?(p) } && MockCard::Probe.probe?(env)

        input = env["rack.input"]
        body = input.read.to_s
        input.rewind
        secret = @probe_secret.respond_to?(:call) ? @probe_secret.call : @probe_secret
        return @app.call(env) unless MockCard::Probe.verify(env, body, secret.to_s)

        [200, { "content-type" => "application/json", MockCard::Probe::ACK_HEADER.downcase => "skipped" }, ['{"received":true,"probe":true}']]
      end
    end
  end
end
