require 'test_helper'
require 'stripe_mock'

class ProMembershipManagerTest < ActiveSupport::TestCase
  before { StripeMock.start }
  after { StripeMock.stop }

  let(:user) { build(:user, :with_stripe) }
  let(:manager) { ProMembershipManager.new user }
  let(:stripe_helper) { StripeMock.create_test_helper }

  test "#subscribe! works for the normal case" do
    plan = ProMembershipPlan.find(1)

    PaymentMethod::StripeProvider.expects(:charge!).with(user, plan.amount)
    manager.expects(:give_pro!).with(user, plan.duration.months)

    assert_difference -> {ActionMailer::Base.deliveries.size }, +1 do
      manager.subscribe! plan
    end

    user.pro_membership_plan.id.must_equal plan.id
    user.billing_id.wont_be_nil
  end

  test "subscribe! raises an error when charging the card fails" do
    StripeMock.prepare_card_error(:card_declined)
    plan = ProMembershipPlan.find(1)

    manager.expects(:give_pro!).never

    assert_raises Stripe::CardError do
      manager.subscribe! plan
    end
  end
  
  test "subscribe! to a recurring plan does not charge pro users immediately" do
    Timecop.freeze do
      user = build(:user, :with_stripe, pro_expires_at: 10.years.from_now)
      manager = ProMembershipManager.new(user)
      plan = ProMembershipPlan.find(1)

      manager.expects(:give_pro!).never
      PaymentMethod::StripeProvider.expects(:charge!).never

      manager.subscribe! plan
    end
  end

  test "subscribe! to a non-recurring plan does charge pro users immediately" do
    user = build(:user, :with_stripe, pro_expires_at: 1.day.from_now,
                                      pro_membership_plan_id: 1)
    manager = ProMembershipManager.new(user)
    plan = ProMembershipPlan.find(5)

    manager.expects(:give_pro!).with(user, plan.duration.months)
    PaymentMethod::StripeProvider.expects(:charge!).with(user, plan.amount)

    manager.subscribe! plan
  end

  test "gift! works correctly for the normal case" do
    gift_to = build(:user)
    plan = ProMembershipPlan.find(5)

    PaymentMethod::StripeProvider.expects(:charge!).with(user, plan.amount)
    manager.expects(:give_pro!).with(gift_to, plan.duration.months)

    assert_difference -> {ActionMailer::Base.deliveries.size }, +1 do
      manager.gift! plan, gift_to, "hi"
    end

    gift_to.billing_id.must_be_nil
    gift_to.pro_membership_plan.must_be_nil
  end

  test "gift! raises an error if we try to gift a recurring plan" do
    gift_to = build(:user)
    plan = ProMembershipPlan.find(1)

    PaymentMethod::StripeProvider.expects(:charge!).never
    manager.expects(:give_pro!).never

    assert_raises RuntimeError do
      manager.gift! plan, gift_to, "hi"
    end
  end

  test "renew! works correctly for the normal case" do
    user = create(:user, :with_stripe, pro_expires_at: 1.hour.from_now,
                                       pro_membership_plan_id: 1)
    manager = ProMembershipManager.new(user)
    plan = ProMembershipPlan.find(1)

    PaymentMethod::StripeProvider.expects(:charge!).with(user, plan.amount)
    manager.expects(:give_pro!).with(user, plan.duration.months)

    manager.renew!
  end

  test "renew! should fire off a failure email when charging the card fails" do
    StripeMock.prepare_card_error(:card_declined)
    user = build(:user, :with_stripe, pro_expires_at: 1.day.from_now,
                                      pro_membership_plan_id: 1)
    manager = ProMembershipManager.new(user)

    assert_no_difference ->{ user.pro_expires_at } do
      assert_difference ->{ ActionMailer::Base.deliveries.count }, +1 do
        manager.renew!
      end
    end
  end

  test "renew! should fire off a success email when charging the card works in a retry" do
    user = build(:user, :with_stripe, pro_expires_at: 1.day.from_now,
                                      pro_membership_plan_id: 1)
    manager = ProMembershipManager.new(user)

    assert_difference ->{ ActionMailer::Base.deliveries.count }, +1 do
      manager.renew! attempt_number: 2
    end
  end

  test "cancel! unsets the user's plan" do
    user = build(:user, pro_expires_at: 1.day.from_now,
                        pro_membership_plan_id: 1)
    manager = ProMembershipManager.new(user)

    assert_difference ->{ ActionMailer::Base.deliveries.count }, +1 do
      manager.cancel!
    end

    user.pro_membership_plan_id.must_be_nil
  end

  test "give_pro! should add time from now if the user lacks pro" do
    Timecop.freeze do
      user = build(:user, pro_expires_at: nil)
      manager = ProMembershipManager.new(user)
      manager.send(:give_pro!, user, 1.month)

      user.pro_expires_at.must_equal 1.month.from_now
    end
  end

  test "give_pro! should add time from now if the user's pro is expired" do
    Timecop.freeze do
      user = build(:user, pro_expires_at: 1.day.ago)
      manager = ProMembershipManager.new(user)
      manager.send(:give_pro!, user, 1.month)

      user.pro_expires_at.must_equal 1.month.from_now
    end
  end

  test "give_pro! should add time to expiration if the user has pro" do
    Timecop.freeze do
      user = build(:user, pro_expires_at: 1.month.from_now)
      manager = ProMembershipManager.new(user)

      assert_difference ->{ user.pro_expires_at }, 1.month do
        manager.send(:give_pro!, user, 1.month)
      end
    end
  end
end
