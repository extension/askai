# run this with bin/rails dev:reset

namespace :dev do
  desc "Reset and reseed the database"
  task reset: :environment do
    puts "💥 Dropping database..."
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
    puts "✅ Local DB reset and seeded."
  end
end
