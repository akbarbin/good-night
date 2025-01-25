module BaseAPI
  module V1
    module User
      class Follows < Grape::API
        helpers do
          def current_user
            @current_user ||= ::User.find_by(token: headers["Authorization"])
          end

          def authenticate!
            error!({ message: "Unauthorized or user not found" }, 401) unless current_user
          end
        end

        namespace :user do
          resource :follows do
            before { authenticate! }

            desc "Follow a user"
            params do
              requires :id, type: Integer, desc: "User ID"
            end
            put ":id" do
              initiated_follow = current_user.initiated_follows.new(followed_id: params[:id])
              if initiated_follow.save
                { id: initiated_follow.id, followed_id: initiated_follow.followed_id }
              else
                error!({ message: "Failed to follow user", errors: initiated_follow.errors }, 422)
              end
            end

            desc "Unfollow a user"
            params do
              requires :id, type: Integer, desc: "User ID"
            end
            delete ":id" do
              initiated_follow = current_user.initiated_follows.find_by(followed_id: params[:id])
              if initiated_follow.destroy
                status(:no_content)
              else
                error!({ message: "Failed to unfollow user", errors: initiated_follow.errors }, 422)
              end
            end
          end
        end
      end
    end
  end
end
