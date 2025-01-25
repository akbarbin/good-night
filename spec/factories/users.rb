FactoryBot.define do
  factory :user do
    name  { Faker::Name.name }
    token { Faker::Internet.password }

    factory :user_with_records do
      transient do
        records_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:record, evaluator.records_count, user: user)
      end
    end
  end
end
