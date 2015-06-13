require 'test_helper'
require 'stripe_mock'

class ProMembershipsControllerTest < ActionController::TestCase
  test "must be signed in" do
    post :create, format: :json
    assert_response 403
  end

  class SignedInProMembershipsControllerTest < ActionController::TestCase
    setup do
      @user = users(:vikhyat)
      sign_in @user
      @stripe = StripeMock.create_test_helper
      StripeMock.start
    end

    teardown do
      StripeMock.stop
    end

    test "requires both token and valid plan_id" do
      requests = [{}, {plan_id: 5}, {token: ""}, {token: "derp"},
                  {token: "", plan_id: 5}, {token: "derp", plan_id: -1}]

      requests.each do |req|
        post :create, req
        assert_response 400
      end
    end

    test "regular subscription works" do
      token = @stripe.generate_card_token
      post :create, {token: token, plan_id: 5}

      @user.reload
      assert_response 200
      assert @user.pro?
    end

    test "change of subscription does not charge credit cards" do
      StripeMock.prepare_card_error(:card_declined)
      token = @stripe.generate_card_token
      @user.pro_expires_at = Time.now + 5.days
      @user.pro_membership_plan_id = 1
      @user.save!
      post :create, {token: token, plan_id: 2}

      @user.reload
      assert_response 200
      assert_equal 2, @user.pro_membership_plan.id
    end

    test "regular gifting works" do
      token = @stripe.generate_card_token
      gift_to = users(:josh)
      gift_to.update_attributes! pro_expires_at: Time.now - 10.days
      assert !gift_to.pro?
      post :create, {token: token, plan_id: 5, gift: true,
                     gift_to: gift_to.id, gift_message: ""}

      assert_response 200
      assert gift_to.reload.pro?
    end

    test "cannot gift recurring plans" do
      token = @stripe.generate_card_token
      gift_to = users(:josh)
      gift_to.update_attributes! pro_expires_at: Time.now - 10.days
      assert !gift_to.pro?
      post :create, {token: token, plan_id: 1, gift: true,
                     gift_to: gift_to.id, gift_message: ""}

      assert_response 400
      assert !gift_to.reload.pro?
    end
  end
end
