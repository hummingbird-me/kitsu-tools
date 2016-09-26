module JSONAPI
  module Authorization
    class PunditAuthorizer < DefaultPunditAuthorizer
      def create_resource(source_model)
        ::Pundit.authorize(user, source_model, 'create?')
      end

      def update_resource(source_model)
        ::Pundit.authorize(user, source_model, 'update?')
      end
    end
  end
end

