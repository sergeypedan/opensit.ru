web: bundle exec puma --config config/puma.rb --daemon
redis: redis-server config/redis.conf
sidekiq: bundle exec sidekiq -e production -C config/sidekiq.yml -q mailers
