module BaseAPI
  module V1
    module User
      class Follows < Grape::API
        namespace :user do
          resource :follows do
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
