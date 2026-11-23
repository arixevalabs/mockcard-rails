# frozen_string_literal: true

# Tests for the Rack probe guard, using the shared conformance fixtures. Author: Arixeva Labs <hello@arixevalabs.com>
require "json"
require "minitest/autorun"
require "rack/test"
require "rack/builder"
require "openssl"
require_relative "../lib/mockcard-rails"

class ProbeGuardTest < Minitest::Test
  include Rack::Test::Methods

  SECRET = JSON.parse(File.read(File.expand_path("../../conformance/probe-signatures.json", __dir__)))["secret"]

  def setup = @handled = 0

  def app
    handled = ->(_env) { @handled += 1; [200, {}, ["processed"]] }
    MockCard::Rails::ProbeGuard.new(handled, probe_secret: -> { SECRET }, paths: ["/webhooks"])
  end

  def sign(body, t = Time.now.to_i) = "t=#{t},v1=#{OpenSSL::HMAC.hexdigest('SHA256', SECRET, "#{t}.#{body}")}"

  def test_verified_probe_is_acknowledged_without_reaching_the_app
    body = '{"type":"payment_intent.succeeded"}'
    post "/webhooks/stripe", body, "HTTP_MOCKCARD_PROBE" => "1", "HTTP_MOCKCARD_SIGNATURE" => sign(body)
    assert_equal "skipped", last_response.headers["mockcard-probe-ack"]
    assert_equal 0, @handled
  end

  def test_forged_probes_other_paths_and_normal_events_reach_the_app
    body = "{}"
    post "/webhooks/stripe", body, "HTTP_MOCKCARD_PROBE" => "1", "HTTP_MOCKCARD_SIGNATURE" => sign(body, Time.now.to_i - 3600)
    post "/other", body, "HTTP_MOCKCARD_PROBE" => "1", "HTTP_MOCKCARD_SIGNATURE" => sign(body)
    post "/webhooks/stripe", body
    assert_equal 3, @handled
  end

  def test_body_is_still_readable_after_the_guard_inspected_it
    seen = nil
    guard = MockCard::Rails::ProbeGuard.new(->(env) { seen = env["rack.input"].read; [200, {}, []] }, probe_secret: SECRET)
    Rack::MockRequest.new(guard).post("/hook", input: "{\"a\":1}", "HTTP_MOCKCARD_PROBE" => "1", "HTTP_MOCKCARD_SIGNATURE" => "t=1,v1=#{'0' * 64}")
    assert_equal '{"a":1}', seen
  end
end
