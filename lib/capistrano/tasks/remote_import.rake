namespace :remote do
  desc "Run import:questions remotely with a limit"
  task :import_questions do
    limit = ENV['LIMIT'] || '100'  # Default to 100 if no ENV var set

    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env, 'production') do
          execute :bundle, :exec, :rails, "import:questions[#{limit}]"
        end
      end
    end
  end
end
