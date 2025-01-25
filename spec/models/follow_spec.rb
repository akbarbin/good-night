require 'rails_helper'

RSpec.describe Follow, type: :model do
  it { should belong_to(:follower) }
  it { should belong_to(:followed) }

  it 'is invalid to follow yourself' do
    user = create(:user)
    follow = build(:follow, follower: user, followed: user)

    expect(follow).not_to be_valid
    expect(follow.errors[:followed]).to include("You cannot follow yourself")
  end
end
