# url_shortener

   A URL shortener application in Ruby on Rails

## Introduction
- An URL shortener full-stack application using any database engine, Ruby On Rails.

## Pre-requisites


## Steps to run the application.
- Clone the repository.
- Go inside the cloned repository directory.
- Run the below command to start the application and databases
  ```
   rake db:migrate
   bundle install
   rails s
  ```
  The above command will start the application in the daemon mode
- Open http://localhost:3000/ in the browser to run and test the URL shortener.

## Features:

### 1. URL shortener UI:
- Allow create and login an account. 
- Allow put a URL into the home page and get back a URL of the shortest possible length.
- Allow managing your links, edit, create, destroy, etc.
- You will be redirected to the full URL when you enter the short URL (ex: http://app.com/aSdF​ =>​ ​https://google.com​).
- You can see a list of your links, ordered by creation date, and see how many times your link was clicked.

### 2. Endpoint:
- Allow user login to get API key to access system. (http://localhost:3000/api/v1/authenticate)

   ``curl -X POST -H "Content-Type: application/json" -d '{"email": "test@gmail.com", "password": 123456}' http://localhost:3000/api/v1/authenticate
   ``

- Allow user with the above API key to shortening new URLs. (http://localhost:3000/api/v1/generate_link )

  ``curl  -X POST -H "Content-Type: application/json" -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNjU5Mzg4MDcxfQ.R7Ypx5L0G3v6r9GVnlQ6juIvvSkfmqthhawqkg8Ke-w"  -d '{"url":"http://google.com"}' http://localhost:3000/api/v1/generate_link
  ``
- Allow getting all your links with results be paginated. (http://localhost:3000/api/v1/get_all_links)

   ``curl  -H "Content-Type: application/json" -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNjU5Mzg4MDcxfQ.R7Ypx5L0G3v6r9GVnlQ6juIvvSkfmqthhawqkg8Ke-w"  http://localhost:3000/api/v1/get_all_links
   ``
## About the algorithm used for generating the URL shortcode
Looking at the shortened path string (ex: http://app.com/aSdF), there are two parts: a domain name and a short string of characters. What we need to do is generate that short string by random and control it as a unique value. We then map this string to the original URL string in a table. Every time we retrieve the shortened line rely on it to redirect the user to the original URL.

