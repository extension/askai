# config/initializers/load_dotenv.rb
if Rails.env.production?
  require 'dotenv'
  Dotenv.load('/home/deployer/apps/askai/shared/.env')
end