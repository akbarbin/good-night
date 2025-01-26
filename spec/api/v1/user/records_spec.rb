require "rails_helper"

RSpec.describe "Api::V1::User::Records", type: :request do
  let(:headers) { { "Authorization" => valid_token } }
  let(:valid_token) { "valid_token" }
  let(:invalid_token) { "invalid_token" }

  shared_examples_for "no_token_error" do
    context "when no token is provided" do
      let(:headers) { nil }

      include_examples "user_not_found_error"
    end
  end

  shared_examples_for "invalid_token_error" do
    context "when an invalid token is provided" do
      let(:headers) { { "Authorization" => invalid_token } }

      include_examples "user_not_found_error"
    end
  end

  shared_examples_for "user_not_found_error" do
    it "returns an error" do
      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Unauthorized or user not found")
    end
  end

  describe "GET /api/v1/user/records" do
    subject(:records_request) { get "/api/v1/user/records", headers: headers, params: { page: 1, items: 20 } }

    let!(:user) { create(:user_with_records, records_count: 50, token: valid_token) }

    before { subject }

    context "when a valid token is provided" do
      it "returns a list of records ordered by created time" do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["records"].size).to eq(20)
        expect(json_response["records"][0]["id"]).to eq(user.records.first.id)
      end

      context "when user has no records" do
        let(:user) { create(:user, token: valid_token) }

        it "returns an empty list" do
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response["records"].size).to eq(0)
        end
      end
    end

    include_examples "invalid_token_error"
    include_examples "no_token_error"
  end

  describe "POST /api/v1/user/records/clock_in" do
    subject(:records_request) { post path, headers: headers }

    let!(:user) { create(:user, token: valid_token) }
    let(:path) { "/api/v1/user/records/clock_in" }

    context "when a valid token is provided" do
      it "creates a clock in record" do
        subject
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).not_to be_nil
        expect(json_response["clocked_in_at"]).not_to be_nil
        expect(user.records.count).to eq(1)
      end

      context "when previous clock in record is not closed yet" do
        let!(:record) { create(:record, clocked_out_at: nil, user: user) }

        it "returns a 422 error with error message" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response["message"]).to eq("Active clock in record exists")
        end
      end
    end

    context "when an invalid token is provided" do
      let(:headers) { { "Authorization" => invalid_token } }

      before { subject }

      include_examples "user_not_found_error"
    end

    context "when no token is provided" do
      let(:headers) { nil }

      before { subject }

      include_examples "user_not_found_error"
    end

    context "when record is failed to save" do
      before { allow_any_instance_of(Record).to receive(:save).and_return(false) }

      it "returns a 422 error with error message" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Failed to clock in")
      end
    end
  end

  describe "POST /api/v1/user/records/clock_out" do
    subject(:records_request) { post "/api/v1/user/records/clock_out", headers: headers }

    let!(:user) { create(:user, token: "valid_token") }
    let!(:record) { create(:clocked_in_record, user: user) }

    context "when a valid token is provided" do
      before { subject }

      it "saves a clock out from previous clock in record" do
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).not_to be_nil
        expect(json_response["clocked_out_at"]).not_to be_nil
        expect(json_response["time_in_bed"]).not_to be_nil
        expect(user.records.count).to eq(1)
      end

      context "when previous clock in record is not found" do
        let!(:record) { create(:record, clocked_in_at: nil, user: user) }

        it "returns a 422 error with error message" do
          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)
          expect(json_response["message"]).to eq("No active clock in record")
        end
      end
    end

    context "when an invalid token is provided" do
      let(:headers) { { "Authorization" => invalid_token } }

      before { subject }

      include_examples "user_not_found_error"
    end

    context "when no token is provided" do
      let(:headers) { nil }

      before { subject }

      include_examples "user_not_found_error"
    end

    context "when record is failed to save" do
      before do
        allow_any_instance_of(Record).to receive(:update).and_return(false)
        subject
      end

      it "returns a 422 error with error message" do
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Failed to clock out")
      end
    end
  end
end
