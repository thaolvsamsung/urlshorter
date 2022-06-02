json.(user, :id, :email, :name)
json.token user.generate_api_key