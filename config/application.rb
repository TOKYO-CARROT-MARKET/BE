require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TokyoCarrotMarketBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    config.autoload_lib(ignore: %w[assets tasks])

    config.api_only = true

    session_options = {
      key: "_tokyo_carrot_market_session",
      same_site: Rails.env.production? ? :none : :lax,
      secure: Rails.env.production?
    }

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, session_options

  end
end
