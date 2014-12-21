require 'test_helper'
require 'stripe_mock'

class ProMembershipManagerTest < ActiveSupport::TestCase
  setup do
    @user = users(:vikhyat)
    @manager = ProMembershipManager.new(@user)
    @stripe = StripeMock.create_test_helper
    StripeMock.start
  end

  teardown do
    StripeMock.stop
  end

  test "subscribe! works for the normal case" do
    plan = ProMembershipPlan.find(1)
    token = @stripe.generate_card_token
    @manager.subscribe! plan, token

    assert @user.pro?
    assert_equal token, @user.stripe_token
    assert_equal plan.id, @user.pro_membership_plan.id
  end

  test "subscribe! doesn't add from a previous pro_expires_at date" do
    @user.update_attributes pro_expires_at: Time.now-10.years
    plan = ProMembershipPlan.find(1)
    token = @stripe.generate_card_token
    Timecop.freeze do
      @manager.subscribe! plan, token
      assert_equal Time.now+plan.duration.months, @user.pro_expires_at
    end
  end

  test "subscribe! raises an error when charging the card fails" do
    StripeMock.prepare_card_error(:card_declined)
    plan = ProMembershipPlan.find(1)
    token = @stripe.generate_card_token

    assert_raises Stripe::CardError do
      @manager.subscribe! plan, token
    end

    assert !@user.pro?
  end

  test "subscribe! to a recurring plan does not immediately charge pro users for a recurring subscription" do
    StripeMock.prepare_card_error(:card_declined)
    @user.pro_expires_at = Time.now + 1.day
    @user.pro_membership_plan_id = 1
    @user.save!
    plan = ProMembershipPlan.find(2)
    token = @stripe.generate_card_token

    @manager.subscribe! plan, token
    assert @user.pro_expires_at < Time.now + 2.days
    assert_equal 2, @user.pro_membership_plan.id
  end

  test "subscribe! to a non-recurring plan does charge pro users for a one-time subscription" do
    @user.pro_expires_at = Time.now + 1.day
    @user.pro_membership_plan_id = 1
    @user.save!
    plan = ProMembershipPlan.find(5)
    token = @stripe.generate_card_token

    @manager.subscribe! plan, token
    assert @user.pro_expires_at > Time.now + 2.days
  end

  test "cancel! unsets the user's plan" do
    @user.pro_expires_at = Time.now + 1.day
    @user.pro_membership_plan_id = 1
    @user.save!
    assert @user.pro?

    @manager.cancel!

    assert @user.pro?
    assert @user.pro_membership_plan_id.nil?
  end
end
