# This is for Heroku

# Example: https://github.com/puma/puma/blob/master/examples/config.rb
# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#config

environment "production"

port ENV['PORT'] || 3000

preload_app!

rackup DefaultRackup

# # Min and Max threads per worker
threads 1, Integer(ENV['MAX_THREADS'] || 5)

# # Change to match your CPU core count
workers Integer(ENV['WEB_CONCURRENCY'] || 1)

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
