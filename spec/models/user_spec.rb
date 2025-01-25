require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:records).dependent(:destroy) }
  it { should have_many(:initiated_follows).class_name("Follow").dependent(:destroy) }
  it { should have_many(:followed_users).through(:initiated_follows).source(:followed) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:token) }
  it { should validate_uniqueness_of(:token) }
end
