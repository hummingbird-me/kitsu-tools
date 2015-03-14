class PaymentMethod
  class StripeProvider
    def self.exchange_token(user, token)
      # TODO: update existing customer with new card
      ::Stripe::Customer.create(email: user.email, card: token)
    end

    def self.customer(user, token=nil)
      ::Stripe::Customer.retrieve(user.billing_id)
    end

    # Of note: amount should be a BigDecimal of 0.00 format
    def self.charge!(customer, amount, description='Hummingbird PRO')
      if customer.is_a? User
        customer_id = customer.billing_id
      else
        customer_id = customer.id
      end
      ::Stripe::Charge.create(
        customer: customer_id,
        # Stripe wants this in integer form
        amount: (amount * 100).to_i,
        description: description,
        currency: 'usd'
      )
    end
  end
end
