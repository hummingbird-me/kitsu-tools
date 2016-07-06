require_dependency 'jsonapi/searchable_request'

module SearchableController
  extend ActiveSupport::Concern

  def process_request
    @request = SearchableRequest.new(params,
      context: context,
      key_formatter: key_formatter,
      server_error_callbacks: self.class.server_error_callbacks || [])

    if @request.errors.empty?
      operation_results = create_operations_processor.process(@request)
      render_results(operation_results)
    else
      render_errors(@request.errors)
    end

  rescue => e
    handle_exceptions(e)
  ensure
    unless response.body.empty?
      response.headers['Content-Type'] = JSONAPI::MEDIA_TYPE
    end
  end
end
