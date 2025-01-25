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
            before { authenticate! }

            desc "Get user records"
            get do
              current_user.records.order(:created_at)
            end

            desc "Add clock in record"
            post :clock_in do
              record = current_user.records.new(clock_in_at: Time.current)
              if record.save
                { id: record.id, clock_in: record.clock_in_at }
              else
                error!({ message: "Failed to clock in", errors: record.errors }, 422)
              end
            end

            desc "Save clock out in previous clock-in record"
            post :clock_out do
              record = current_user.records.find_by(clock_out_at: nil)
              if record
                if record.update(clock_out_at: Time.current)
                  { id: record.id, clock_in: record.clock_in_at, clock_out: record.clock_out_at }
                else
                  error!({ message: "Failed to clock out", errors: record.errors }, 422)
                end
              else
                error!({ message: "No active clock in record" }, 404)
              end
            end
          end
        end
      end
    end
  end
end
