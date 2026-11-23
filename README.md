# mockcard-rails

MockCard for Rails: guard your payment webhook routes against MockCard's production probes, with
secrets from Rails credentials. Chaos runs and test helpers come from the `mockcard` gem.

Author: Arixeva Labs <hello@arixevalabs.com> · [mockcard.io](https://www.mockcard.io) · MIT

```ruby
gem "mockcard-rails"
```

```sh
bin/rails generate mockcard:install
bin/rails credentials:edit   # mockcard: { api_key: "mc_…", probe_secret: "mcp_…" }
```

The initializer lists the webhook paths to guard (`config.mockcard.webhook_paths`). Verified MockCard
probes to those paths get `200` + `MockCard-Probe-Ack: skipped` before Rails routes them; everything
else, including forged probes, reaches your controllers as usual. Works with the Pay gem's webhook route.

For chaos runs in your test suite, see the [`mockcard`](https://rubygems.org/gems/mockcard) gem.
