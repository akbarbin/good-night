module BaseAPI
  module V1
    module User
      class FollowedUsers < Grape::API
        helpers APIHelper

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
            params do
              optional :page, type: Integer, default: 1
              optional :items, type: Integer, default: 10
            end
            get :records do
              collection = current_user
                .followed_users_records
                .from_prev_week
                .order(time_in_bed: :desc)

              pagy, records = pagy(collection, page: params[:page], items: params[:items])
              {
                records: records,
                metadata: pagy_metadata(pagy)
              }
            end
          end
        end
      end
    end
  end
end
