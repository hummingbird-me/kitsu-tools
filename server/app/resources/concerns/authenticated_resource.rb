module AuthenticatedResource
  extend ActiveSupport::Concern

  # Get current user from context
  def current_user
    @context[:current_user]
  end

  # The Pundit policy for the model
  def pundit
    @pundit ||= Pundit::PolicyFinder.new(@model)
  end

  # The policy instance with the current user from the context
  def policy
    return unless pundit.policy
    @policy ||= pundit.policy.new(current_user, @model)
  end

  # Raise a Pundit::NotAuthorizedError for the given query
  def not_authorized!(query)
    fail Pundit::NotAuthorizedError, query: query,
                                     record: @model,
                                     policy: pundit.policy
  end

  # Limit scope of relations based on policies
  def records_for(relation_name)
    klass = self.class._relationships[relation_name].class_name.constantize
    policy = Pundit::PolicyFinder.new(klass)
    scope = _model.public_send(relation_name)
    scope = policy.scope.new(current_user, scope)
    scope.resolve
  end

  # Limit scope of finders based on policy
  class_methods do
    def records(options = {context: {}})
      current_user = options[:context][:current_user]
      policy = Pundit::PolicyFinder.new(_model_class.all)
      scope = policy.scope.new(current_user, _model_class)
      scope.resolve
    end
  end

  # Hook in our authorization callbacks
  before_create { not_authorized! :create? unless policy && policy.create? }
  before_update { not_authorized! :update? unless policy && policy.update? }
  before_remove { not_authorized! :destroy? unless policy && policy.destroy? }
end
