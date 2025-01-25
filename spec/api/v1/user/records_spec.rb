require "rails_helper"

RSpec.describe "Api::V1::User::Records", type: :request do
  describe "GET /api/v1/user/records" do
    let!(:user) { create(:user_with_records, records_count: 5, token: "valid_token") }

    context "when a valid token is provided" do
      it "returns a list of records" do
        get "/api/v1/user/records", headers: { "Authorization" => "valid_token" }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(5)

        # Check ascending order
        expect(json_response[0]["id"]).to eq(user.records.first.id)
      end

      context "when user has no records" do
        let(:user) { create(:user, token: "valid_token") }

        it "returns an empty list" do
          get "/api/v1/user/records", headers: { "Authorization" => "valid_token" }

          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response.size).to eq(0)
        end
      end
    end

    context "when an invalid token is provided" do
      it "returns an error" do
        get "/api/v1/user/records", headers: { "Authorization" => "invalid_token" }

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Unauthorized or user not found")
      end
    end

    context "when no token is provided" do
      it "returns an error" do
        get "/api/v1/user/records"

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Unauthorized or user not found")
      end
    end
  end

  describe "POST /api/v1/user/records/clock_in" do
    let!(:user) { create(:user, token: "valid_token") }

    context "when a valid token is provided" do
      it "creates a clock in record" do
        post "/api/v1/user/records/clock_in", headers: { "Authorization" => "valid_token" }

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).not_to be_nil
        expect(json_response["clock_in"]).not_to be_nil
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

  describe "POST /api/v1/user/records/clock_out" do
    let!(:user) { create(:user, token: "valid_token") }
    let!(:record) { create(:clocked_in_record, user: user) }

    context "when a valid token is provided" do
      it "saves a clock out from previous clock in record" do
        post "/api/v1/user/records/clock_out", headers: { "Authorization" => "valid_token" }

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).not_to be_nil
        expect(json_response["clock_out"]).not_to be_nil
        expect(user.records.count).to eq(1)
      end

      context "when previous clock in record is not found" do
        let(:record) { nil }

        it "returns a 422 error with error message" do
          post "/api/v1/user/records/clock_out", headers: { "Authorization" => "valid_token" }

          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)
          expect(json_response["message"]).to eq("No active clock in record")
        end
      end
    end

    context "when an invalid token is provided" do
      it "returns an error" do
        post "/api/v1/user/records/clock_out", headers: { "Authorization" => "invalid_token" }

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Unauthorized or user not found")
      end
    end

    context "when no token is provided" do
      it "returns an error" do
        post "/api/v1/user/records/clock_out"

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Unauthorized or user not found")
      end
    end

    context "when record is failed to save" do
      before do
        allow_any_instance_of(Record).to receive(:update).and_return(false)
      end

      it "returns a 422 error with error message" do
        post "/api/v1/user/records/clock_out", headers: { "Authorization" => "valid_token" }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Failed to clock out")
      end
    end
  end
end
