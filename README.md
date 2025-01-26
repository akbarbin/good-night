# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 3.4.1

* System dependencies Rails 8.0.1

* Database PostgreSQL

* Database creation for development
```ruby
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
bin/dev
```

* Database initialization for test
```ruby
RAILS_ENV=test bundle exec rake db:create
RAILS_ENV=test bundle exec rake db:migrate
  ```

* How to run the test suite
```ruby
bundle exec rspec
```

# API endpoints
* Clock In
```
curl -H "Authorization: token" -X POST http://localhost:3000/api/v1/user/records/clock_in
```

* Clock Out
```
curl -H "Authorization: token" -X POST http://localhost:3000/api/v1/user/records/clock_in
```

* Records
```
curl -H "Authorization: token" -X GET http://localhost:3000/api/v1/user/records
```

* Follow user
```
curl -H "Authorization: token" -X PUT http://localhost:3000/api/v1/user/follows/:id
```

* Unfollow user
```
curl -H "Authorization: token" -X DELETE http://localhost:3000/api/v1/follows/:id
```

* Followed users records
```
curl -H "Authorization: token" -X GET http://localhost:3000/api/v1/user/followed_users/records
```
