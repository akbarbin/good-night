class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followed_id, message: "You cannot follow the same user twice" }

  validate :cannot_follow_yourself

  private

  def cannot_follow_yourself
    errors.add(:followed, "You cannot follow yourself") if follower_id == followed_id
  end
end
