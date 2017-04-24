# README

A simple Rails API application, that allows basic CRUD actions for booking
holiday rentals.

To be able to run the application locally, please follow the steps below:

* You need to have Ruby installed. The app has been developed with Ruby
  2.3.0p0, so use this version for the best performance/compatibility.

* Install needed gems, by running `bundle install` (you need to have Bundler gem
  installed first, if you don't, run `gem install bundler` before the previous
  command).

* Postgres is used for the database layer, so be sure to have it on your machine
  as well. After you do, run `rake db:create` and `rake db:migrate`.

* After the above, you will be able to run the server, by firing `rails server`
  command.

* To run test suite, use `rails spec` or `rspec` commands.

# TODOS:

* add seeds for easier DB interaction from the beginning

* check `TODO:` remarks in the code and fix those
