module BaseAPI
  module V1
    class Base < Grape::API
      version 'v1', using: :path

      mount BaseAPI::V1::User::FollowedUsers
      mount BaseAPI::V1::User::Follows
      mount BaseAPI::V1::User::Records
    end
  end
end
