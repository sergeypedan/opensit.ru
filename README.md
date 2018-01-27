# OpenSit-ru

This is a Russian fork of the original [OpenSit](https://github.com/danbartlett/opensit) — an open source meditation community - a place where meditators can share and develop their practice.

## Getting Started

To install locally for your own hacking pleasure:

1. Clone the repo and `cd` into it.
1. `bundle install`
1. `cp config/database.yml.example config/database.yml`
1. `bundle exec rake db:create db:migrate`
1. `bundle exec guard`
1. Go to `localhost:3000`. Voila!
1. To run the tests: `rake db:test:prepare` and then `rspec spec`
