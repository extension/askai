source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

#pagination
gem 'kaminari'

#authentication
gem 'devise'

#openai access
gem 'ruby-openai'

#background jobs
gem 'sidekiq'

gem 'foreman'

# Load environment variables in all environments
gem 'dotenv-rails', groups: [:development, :test, :production]

# Use Active Storage variants
# gem "image_processing", "~> 1.2"

group :development, :test do
  # Debugging tools
  # gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Security and static analysis
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false

  # Testing and browser automation
  gem 'rspec-rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'

  # Capistrano deployment stack
  gem 'capistrano', '~> 3.17'
  gem 'capistrano-rails'
  # gem 'capistrano-passenger' # Or use capistrano-puma
  gem 'capistrano-rbenv'
  gem 'capistrano-postgresql' # Optional
  gem 'capistrano-puma'
end

group :development do
  # Interactive debugging in the browser
  gem "web-console"
end
