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

  describe "#calculate_duration" do
    let(:record) { create(:record, clocked_out_at: nil) }

    subject { record.calculate_duration }

    context "when only clocked in" do
      it { is_expected.to be_nil }
    end

    context "when clocked in and clocked out" do
      let(:record) { create(:clocked_in_record, clocked_in_at: '2025-01-25 08:00:00', clocked_out_at: '2025-01-25 08:00:10') }

      it { is_expected.to eq(10) }
    end
  end

  describe "#set_time_in_bed" do
    let(:record) { create(:clocked_in_record, time_in_bed: nil) }

    subject { record.update(clocked_in_at: '2025-01-25 08:00:00', clocked_out_at: '2025-01-25 08:00:10') }

    it { expect { subject }.to change { record.time_in_bed }.from(nil).to(10) }
  end
end
