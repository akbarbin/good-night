require "rails_helper"

RSpec.describe "Api::V1::User::Follows", type: :request do
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

  describe "PUT /api/v1/user/follows/:id" do
    subject(:follows_request) { put "/api/v1/user/follows/#{followed_user.id}", headers: headers }

    let!(:follower) { create(:user, token: valid_token) }
    let!(:followed_user) { create(:user) }

    context "when a valid token is provided" do
      it "follows a user" do
        subject
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).not_to be_nil
        expect(json_response["followed_id"]).not_to be_nil
        expect(follower.followed_users.reload.count).to eq(1)
      end
    end

    include_examples "invalid_token_error"
    include_examples "no_token_error"

    context "when record is failed to save" do
      before do
        allow_any_instance_of(Follow).to receive(:save).and_return(false)
        subject
      end

      it "returns a 422 error with error message" do
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Failed to follow user")
      end
    end
  end

  describe "DELETE /api/v1/user/follows/:id" do
    subject(:follows_request) { delete "/api/v1/user/follows/#{followed_user.id}", headers: headers }

    let!(:follower) { create(:user, token: valid_token) }
    let!(:followed_user) { create(:user) }
    let!(:initiated_follow) { create(:follow, follower: follower, followed: followed_user) }

    context "when a valid token is provided" do
      it "Unfollows a user" do
        subject
        expect(response).to have_http_status(:no_content)
        expect(follower.followed_users.count).to eq(0)
      end
    end

    context "when follower is failed to unfollow user" do
      before do
        allow_any_instance_of(Follow).to receive(:destroy).and_return(false)
        subject
      end

      it "returns a 422 error with error message" do
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Failed to unfollow user")
      end
    end
  end
end
