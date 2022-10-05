# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
    - 3.1.2p20

* System dependencies
    - Dependencies are manged through bundler, having the correct ruby version and bundler installed. Run:
    - bundle install

* Configuration
- Database configuration file: `config/database.yml`

* Database creation
- The configured database is SQlite3, this is appropriate for testing and demonstration purposes only

* Database initialization
- create the database and Insert users from seed file
    - bin/rails db:setup

* How to run the test suite
- The test suite can be ran with the command:
    - bin/rails test
    
* Test user
    - user_name: 'some_user', password: 'some_password'