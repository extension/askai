namespace :remote do
  desc "Run db:seed remotely using existing lib/tasks/db.rake"
  task :seed do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env, 'production') do
          execute :bundle, :exec, :rake, "db:seed"
        end
      end
    end
  end
end