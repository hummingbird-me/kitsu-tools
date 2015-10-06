module CurrentUserHelper
  def current_user=(user)
    @controller.send(:define_singleton_method, :current_user) { user || super }
  end
end

RSpec.configure do |config|
  config.include CurrentUserHelper
end
