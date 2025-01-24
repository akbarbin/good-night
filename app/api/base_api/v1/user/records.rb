module BaseAPI
  module V1
    module User
      class Records < Grape::API
        helpers do
          def current_user
            @current_user ||= ::User.find_by(token: headers["Authorization"])
          end

          def authenticate!
            error!({ message: "Unauthorized or user not found" }, 401) unless current_user
          end
        end

        namespace :user do
          resource :records do
            desc "Add clock in record"
            post :clock_in do
              authenticate!
              record = current_user.records.new(clock_in_at: Time.current)
              if record.save
                status(:created)
                { clock_in: record.clock_in_at, id: record.id }
              else
                error!({ message: 'Failed to clock in', errors: record.errors }, 422)
              end
            end
          end
        end
      end
    end
  end
end
