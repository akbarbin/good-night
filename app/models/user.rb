class User < ApplicationRecord
  validates :name, :token, presence: true
  validates :token, uniqueness: true
end
