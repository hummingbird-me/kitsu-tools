require 'test_helper'

class PaymentMethod::StripeProviderTest < ActiveSupport::TestCase
  before { StripeMock.start }
  after { StripeMock.stop }

  let(:stripe_helper) { StripeMock.create_test_helper }

  test "#customer" do
    user = build(:user, :with_stripe)
    customer = PaymentMethod::StripeProvider.customer(user)

    customer.must_be_kind_of Stripe::Customer
    customer.email.must_equal user.email
  end

  test "#exchange_token" do
    user = build(:user)
    token = stripe_helper.generate_card_token

    customer = PaymentMethod::StripeProvider.exchange_token(user, token)
    customer.email.must_equal user.email
  end

  test "#charge!" do
    user = build(:user, :with_stripe)

    Stripe::Charge.expects(:create).with({
      customer: user.billing_id,
      amount: 500,
      description: 'hi',
      currency: 'usd'
    })

    PaymentMethod::StripeProvider.charge! user, BigDecimal.new('5.00'), 'hi'
  end
end
