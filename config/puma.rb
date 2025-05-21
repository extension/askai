# Puma configuration file

threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

port ENV.fetch("PORT", 3000)

plugin :tmp_restart

plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# 👇 Wrap all production-specific config
if ENV.fetch("RAILS_ENV", "development") == "production"
  directory '/home/deployer/apps/askai/current'
  rackup "/home/deployer/apps/askai/current/config.ru"
  environment 'production'

  pidfile "/home/deployer/apps/askai/shared/tmp/pids/puma.pid"
  state_path "/home/deployer/apps/askai/shared/tmp/pids/puma.state"
  stdout_redirect "/home/deployer/apps/askai/shared/log/puma.stdout.log", "/home/deployer/apps/askai/shared/log/puma.stderr.log", true

  threads 1, 5
  workers 2
  preload_app!

  bind "unix:///home/deployer/apps/askai/shared/tmp/sockets/puma.sock"

  restart_command 'bundle exec puma'
end