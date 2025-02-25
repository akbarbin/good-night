module BaseAPI
  module V1
    module User
      class FollowedUsers < Grape::API
        helpers APIHelper

        namespace :user do
          resource :followed_users do
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
