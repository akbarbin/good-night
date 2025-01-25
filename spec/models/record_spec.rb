require 'rails_helper'

RSpec.describe Record, type: :model do
  it { should belong_to(:user) }

  describe ".from_prev_week" do
    let!(:record_last_week) { create(:record, created_at: 1.week.ago) }
    let!(:record_last_month) { create(:record, created_at: 1.month.ago) }

    subject { Record.from_prev_week }

    it "returns records from the previous week" do
      expect(subject).to include(record_last_week)
      expect(subject).not_to include(record_last_month)
    end
  end
end
