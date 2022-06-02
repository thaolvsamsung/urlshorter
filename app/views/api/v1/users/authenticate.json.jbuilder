json.user do |json|
  json.partial! 'user', user: current_user
end