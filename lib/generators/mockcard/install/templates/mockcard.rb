# frozen_string_literal: true

# MockCard (https://www.mockcard.io). Secrets live in credentials:
#   bin/rails credentials:edit  →  mockcard: { api_key: "mc_…", probe_secret: "mcp_…" }
Rails.application.configure do
  # Payment webhook paths guarded against MockCard production probes (verified probes get 200 +
  # MockCard-Probe-Ack and never reach your controllers).
  config.mockcard.webhook_paths = ["/webhooks/stripe", "/pay/webhooks"]
end
