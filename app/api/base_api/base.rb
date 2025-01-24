module BaseAPI
  class Base < Grape::API
    format :json
    prefix :api

    mount BaseAPI::V1::Base
  end
end
