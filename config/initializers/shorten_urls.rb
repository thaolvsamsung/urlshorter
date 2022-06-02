Rails.application.configure do
  config.shorten_url = ActiveSupport::OrderedOptions.new
  config.shorten_url.default_redirect = '/'
  config.shorten_url.key_chars = false
  config.shorten_url.unique_key_length = 5
  config.shorten_url.subdomain = false
  config.shorten_url.ignore_robots = false
  config.shorten_url.persist_retries = false
  config.shorten_url.auto_clean_url = true
  config.shorten_url.charset = :alphanum
  config.shorten_url.per_page = 5
end
