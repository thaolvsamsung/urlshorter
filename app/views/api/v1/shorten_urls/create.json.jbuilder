json.shortlink do |json|
  json.partial! 'shorten_url', shortlink: @shorten_url
end