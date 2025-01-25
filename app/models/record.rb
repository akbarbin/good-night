class Record < ApplicationRecord
  belongs_to :user

  before_update :set_time_in_bed

  scope :from_prev_week, -> { where(created_at: DateTime.current.prev_week..DateTime.current) }

  def calculate_duration
    return unless clock_in_at && clock_out_at
    (clock_out_at - clock_in_at).to_i
  end

  private

    def set_time_in_bed
      self.time_in_bed = calculate_duration
    end
end
