FactoryBot.define do
  factory :record do
    state { "MyString" }
    clock_in_at { "2025-01-24 14:10:14" }
    clock_out_at { "2025-01-24 14:10:14" }
    user { nil }
  end
end
