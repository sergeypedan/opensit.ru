web: bundle exec puma --config config/puma/heroku.rb
redis: redis-server config/redis.conf
sidekiq: bundle exec sidekiq -e production -C config/sidekiq.yml -q mailers
