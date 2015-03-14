require 'test_helper'

class PaymentMethodTest < ActiveSupport::TestCase
  test "#lookup" do
    PaymentMethod.lookup('stripe').must_equal PaymentMethod::StripeProvider
  end
end
