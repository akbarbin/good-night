require "rails_helper"

RSpec.describe "Api::V1::User::Records", type: :request do
  describe "POST /api/v1/user/records/clock_in" do
    let!(:user) { create(:user, token: "valid_token") }

    context "when a valid token is provided" do
      it "creates a clock in record" do
        post "/api/v1/user/records/clock_in", headers: { "Authorization" => "valid_token" }

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["clock_in"]).not_to be_nil
        expect(json_response["id"]).not_to be_nil
        expect(user.records.count).to eq(1)
      end
    end

    context "when an invalid token is provided" do
      it "returns an error" do
        post "/api/v1/user/records/clock_in", headers: { "Authorization" => "invalid_token" }

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Unauthorized or user not found")
      end
    end

    context "when no token is provided" do
      it "returns an error" do
        post "/api/v1/user/records/clock_in"

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Unauthorized or user not found")
      end
    end

    context "when record is failed to save" do
      before do
        allow_any_instance_of(Record).to receive(:save).and_return(false)
      end

      it "returns a 422 error with error message" do
        post "/api/v1/user/records/clock_in", headers: { "Authorization" => "valid_token" }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Failed to clock in")
      end
    end
  end
end
