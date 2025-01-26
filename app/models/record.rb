class Record < ApplicationRecord
  belongs_to :user

  before_update :set_time_in_bed

  scope :from_prev_week, -> { where(created_at: DateTime.current.prev_week..DateTime.current) }

  def calculate_duration
    return unless clocked_in_at && clocked_out_at
    (clocked_out_at - clocked_in_at).to_i
  end

  private

    def set_time_in_bed
      self.time_in_bed = calculate_duration
    end
end
