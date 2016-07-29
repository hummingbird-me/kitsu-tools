# Create a new Authorizer for JSONAPI::Authorization that doesn't execute
# `update?` on relationships when creating a new resource.
#
# This issue is currently in discussion @
# https://github.com/venuu/jsonapi-authorization/issues/15
module JSONAPI
  module Authorization
    class PunditAuthorizer < DefaultPunditAuthorizer
      def create_resource(source_class, _related_records)
        ::Pundit.authorize(user, source_class, 'create?')
      end
    end
  end
end
