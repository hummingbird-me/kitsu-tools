module AuthenticatedResource
  extend ActiveSupport::Concern

  # Get current user from context
  def current_user
    @context[:user]
  end

  def token
    @context[:token]
  end

  def has_scopes?(*scopes)
    token && token.acceptable?(scopes + [:all])
  end
  alias_method :has_scope?, :has_scopes?

  class_methods do
    def require_scopes!(*scopes)
      unless has_scopes?(scopes)
        raise OAuth::ForbiddenTokenError.for_scopes(scopes)
      end
    end
    alias_method :require_scope!, :require_scopes!
  end
end
