# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

users = [
  { name: "Reed Greenholt", token: "qSUggxMs66kq" },
  { name: "Reyes Kerluke", token: "5YXJ3bmkRKfWC" },
  { name: "Reuben Blick", token: "cfiQBEk1Xv0" },
  { name: "Brice Aufderhar", token: "8jsQ1f3rm2" }
]

users.each do |user|
  User.find_or_create_by!(name: user[:name], token: user[:token])
end
