FactoryBot.define do
  factory :record do
    clocked_in_at { 1.day.ago }
    clocked_out_at { 1.day.ago + 8.hours }
    time_in_bed { nil }

    user

    factory :clocked_in_record, class: Record do
      clocked_in_at { 1.day.ago }
      clocked_out_at { nil }
    end
  end
end
