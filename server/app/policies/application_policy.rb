class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    true
  end
  alias_method :index?, :show?

  def is_admin?
    user && user.has_role?(:admin, model_class)
  end
  alias_method :create?, :is_admin?
  alias_method :update?, :is_admin?
  alias_method :destroy?, :is_admin?

  def model_class
    record.class || self.class.name.sub('Policy', '').safe_constantize
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
