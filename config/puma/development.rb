# Example: https://github.com/puma/puma/blob/master/examples/config.rb

app_dir    = File.expand_path("../../..", __FILE__)
shared_dir = "#{app_dir}/tmp"
rails_env  = ENV.fetch("RAILS_ENV") { "development" }


# activate_control_app
# bind "unix://#{shared_dir}/sockets/puma.sock"
environment rails_env
pidfile "#{shared_dir}/pids/puma.pid"
port ENV.fetch("PORT") { 3000 }
preload_app!
rackup DefaultRackup
# stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true
state_path "#{shared_dir}/pids/puma.state"
threads 0, Integer(ENV.fetch("MAX_THREADS") { 6 })    # Min and Max threads per worker
workers Integer(ENV.fetch("WEB_CONCURRENCY") { 1 })   # Change to match your CPU core count

# on_worker_boot do
  # require "active_record"
  # ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  # ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
# end
