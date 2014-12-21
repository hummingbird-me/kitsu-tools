class DummyMixpanel
  def method_missing(m, *args, &block)
    true
  end
end
