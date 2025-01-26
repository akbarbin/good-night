module BaseAPI
  module V1
    module User
      class Records < Grape::API
        helpers APIHelper

        namespace :user do
          resource :records do
            desc "Get user records"
            params do
              optional :page, type: Integer, default: 1
              optional :items, type: Integer, default: 10
            end
            get do
              pagy, records = pagy(current_user.records.order(:created_at), page: params[:page], items: params[:items])
              {
                records: records,
                metadata: pagy_metadata(pagy)
              }
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
                  { id: record.id, clock_in: record.clock_in_at, clock_out: record.clock_out_at, time_in_bed: record.time_in_bed }
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
