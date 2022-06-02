json.(shortlink, :id, :url, :unique_key, :click_count, :created_at)
json.short_url "#{request.base_url}/#{shortlink.unique_key}"