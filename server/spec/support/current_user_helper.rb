module CurrentUserHelper
  def sign_in(user)
    @controller.send(:define_singleton_method, :current_user) { user }
  end
end

RSpec.configure do |config|
  config.include CurrentUserHelper
end
