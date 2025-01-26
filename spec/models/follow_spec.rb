require "rails_helper"

RSpec.describe Follow, type: :model do
  it { should belong_to(:follower) }
  it { should belong_to(:followed) }

  it "is invalid to follow the same followed user twice" do
    followed_user = create(:user)
    user = create(:user)
    first_follow = create(:follow, follower: user, followed: followed_user)
    second_follow = build(:follow, follower: user, followed: followed_user)

    expect(second_follow).not_to be_valid
    expect(second_follow.errors[:follower_id]).to include("You cannot follow the same user twice")
  end

  it "is invalid to follow yourself" do
    user = create(:user)
    follow = build(:follow, follower: user, followed: user)

    expect(follow).not_to be_valid
    expect(follow.errors[:followed]).to include("You cannot follow yourself")
  end
end
