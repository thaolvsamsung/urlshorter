json.extract! shorten_url, :id, :owner_id, :owner_type, :url, :unique_key, :click_count, :expires_at, :created_at, :updated_at, :category, :created_at, :updated_at
json.url shorten_url_url(shorten_url, format: :json)
