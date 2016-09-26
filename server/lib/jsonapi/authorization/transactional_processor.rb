module JSONAPI
  module Authorization
    class TransactionalProcessor < AuthorizingProcessor
      skip_callback :create_resource, :before, :authorize_create_resource
      skip_callback :replace_fields, :before, :authorize_replace_fields
      set_callback :replace_fields, :after, :authorize_replace_fields

      def authorize_replace_fields
        source_resource = @resource_klass.find_by_key(
          params[:resource_id],
          context: context
        )
        source_record = source_resource._model

        if source_resource.is_new?
          authorizer.create_resource(source_record)
        else
          authorizer.update_resource(source_record)
        end
      end
    end
  end
end
