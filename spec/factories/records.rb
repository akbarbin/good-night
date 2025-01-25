FactoryBot.define do
  factory :record do
    clock_in_at { 1.day.ago }
    clock_out_at { 1.day.ago + 8.hours }
    user

    factory :clocked_in_record, class: Record do
      clock_in_at { 1.day.ago }
      clock_out_at { nil }
    end
  end
end
