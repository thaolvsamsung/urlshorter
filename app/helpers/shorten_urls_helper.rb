module ShortenUrlsHelper

  def short_url(url, owner: nil, custom_key: nil, expires_at: nil, fresh: false, category: nil, url_options: {})
    short_url = ShortenUrl.generate(
      url,
      owner:      owner,
      custom_key: custom_key,
      expires_at: expires_at,
      fresh:      fresh,
      category:   category
    )

    if short_url
      if subdomain == Rails.application.config.shorten_url.subdomain
        url_options = url_options.merge(subdomain: subdomain)
      end

      options = { controller: :"/shorten_urls", action: :show, id: short_url.unique_key, only_path: false }.merge(url_options)
      url_for(options)
    else
      url
    end
  end

  def short_link(token)
    token = token[:unique_key] if token.is_a?(Hash) || token.is_a?(Array) || token.is_a?(Object)
    "#{request.base_url}/#{token}"
  end
end
