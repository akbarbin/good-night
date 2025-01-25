class Record < ApplicationRecord
  belongs_to :user

  scope :from_prev_week, -> { where(created_at: DateTime.current.prev_week..DateTime.current) }
end
