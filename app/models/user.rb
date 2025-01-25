class User < ApplicationRecord
  has_many :records, dependent: :destroy
  has_many :initiated_follows, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :initiated_follows, source: :followed
  has_many :followed_users_records, through: :followed_users, source: :records

  validates :name, :token, presence: true
  validates :token, uniqueness: true
end
