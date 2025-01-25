require "rails_helper"

RSpec.describe "Api::V1::User::FollowedUsers", type: :request do
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
      subject
      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Unauthorized or user not found")
    end
  end

  describe "GET /api/v1/user/followed_users/records" do
    subject(:follows_request) { get "/api/v1/user/followed_users/records", headers: headers }

    let!(:follower) { create(:user, token: valid_token) }
    let!(:followed_user) { create(:user) }
    let!(:initiated_follow) { create(:follow, follower: follower, followed: followed_user) }
    let!(:followed_user_records) { create_list(:record, 3, user: followed_user) }

    context "when a valid token is provided" do
      it "returns a list of followed users records" do
        subject
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(3)
      end
    end

    include_examples "invalid_token_error"
    include_examples "no_token_error"
  end
end
