# db/seeds.rb

# Seed sources
Source.find_or_create_by!(
  name: "Ask Extension Expert",
  provider: "Ask Extension Expert",
  is_human: true
)

Source.find_or_create_by!(
  name: "Mockup for Testing",
  provider: "Mockup for Testing",
  is_human: false
)

# Seed admin user
User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "password"           # ⚠️ Change this in production
  user.password_confirmation = "password"
  user.admin = true
end

puts "✅ Seeded sources and admin user."
