FactoryBot.define do
  factory :user do
    name  { Faker::Name.name }
    token { Faker::Internet.password }
  end
end
