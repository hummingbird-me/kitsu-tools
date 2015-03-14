class PaymentMethod
  def self.lookup(method)
    ('PaymentMethod::' + method.classify + 'Provider').constantize
  end
end
