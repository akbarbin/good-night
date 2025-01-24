class User < ApplicationRecord
  has_many :records, dependent: :destroy

  validates :name, :token, presence: true
  validates :token, uniqueness: true
end
