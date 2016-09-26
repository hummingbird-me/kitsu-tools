module JSONAPI
  module Authorization
    class TransactionAuthorizingProcessor < AuthorizingOperationsProcessor
      skip_callback :create_resource_operation, :before, :authorize_create_resource
      skip_callback :replace_fields_operation, :before, :authorize_replace_fields
      set_callback :replace_fields_operation, :after, :authorize_replace_fields

      def authorize_replace_fields
        source_resource = @resource_klass.find_by_key(
          params[:resource_id],
          context: context
        )
        source_record = source_resource._model

        if source_record.is_new?
          authorizer.create_resource(source_record)
        else
          authorizer.update_resource(source_record)
        end
      end
    end
  end
end
TransactionalAuthorizationOperationsProcessor = JSONAPI::Authorization::TransactionAuthorizingProcessor
