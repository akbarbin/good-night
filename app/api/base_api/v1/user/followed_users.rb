module BaseAPI
  module V1
    module User
      class FollowedUsers < Grape::API
        helpers do
          def current_user
            @current_user ||= ::User.find_by(token: headers["Authorization"])
          end

          def authenticate!
            error!({ message: "Unauthorized or user not found" }, 401) unless current_user
          end
        end

        namespace :user do
          resource :followed_users do
            before { authenticate! }

            desc "Returns a list of followed users records"
            get :records do
              current_user.followed_users_records
            end
          end
        end
      end
    end
  end
end
