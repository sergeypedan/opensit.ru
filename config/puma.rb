# Example: https://github.com/puma/puma/blob/master/examples/config.rb

app_dir     = File.expand_path("../..", __FILE__)
# cwd         = File.dirname(__FILE__) + "/.."
db_config   = "#{app_dir}/config/database.yml"
log_dir     = "/var/log/puma"
pids_dir    = "/run"
rails_env   = ENV.fetch("RAILS_ENV") { "production" }


# activate_control_app "unix://#{pids_dir}/puma-ctl.sock"
bind "unix://#{pids_dir}/puma.sock"
daemonize true
environment rails_env
pidfile "#{pids_dir}/puma.pid"
port ENV.fetch("PUMA_PORT") { 3000 }
rackup "#{app_dir}/config.ru"
state_path "#{pids_dir}/puma.state"
stdout_redirect "#{log_dir}/access.log", "#{log_dir}/errors.log", true
threads 1, Integer(ENV.fetch("MAX_THREADS") { 6 })  # Min and Max threads per worker
workers Integer(ENV.fetch("WEB_CONCURRENCY") { 1 }) # Change to match your CPU core count


on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file(db_config)[rails_env])
end
