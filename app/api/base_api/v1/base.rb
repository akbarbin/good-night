module BaseAPI
  module V1
    class Base < Grape::API
      helpers do
        def current_user
          @current_user ||= ::User.find_by(token: headers["Authorization"])
        end

        def authenticate!
          error!({ message: "Unauthorized or user not found" }, 401) unless current_user
        end
      end

      version 'v1', using: :path

      before { authenticate! }
      mount BaseAPI::V1::User::FollowedUsers
      mount BaseAPI::V1::User::Follows
      mount BaseAPI::V1::User::Records
    end
  end
end
