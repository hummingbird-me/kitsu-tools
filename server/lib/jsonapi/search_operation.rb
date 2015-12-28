class SearchOperation < JSONAPI::FindOperation
  # Filters which we kick to ElasticSearch for processing
  SEARCH_FILTERS = %w[text genres year season rating]

  # Override JSONAPI::FindOperation's apply method to use ElasticSearch where
  # necessary
  def apply
    filters = verified_filters
    find_opts = {
      context: @context,
      include_directives: @include_directives,
      sort_criteria: @sort_criteria,
      paginator: @paginator
    }
    resource_records = []

    # If we need to, use ElasticSearch to perform the query
    if @resource_klass.should_query?(filters)
      resource_records = @resource_klass.search(filters, find_opts)
    else
      find_opts[:sort_criteria].map! { |x| x[:field] = 'id' if x[:field] == '_score'; x }
      resource_records = @resource_klass.find(filters, find_opts)
    end

    options = {}
    if JSONAPI.configuration.top_level_links_include_pagination
      options[:pagination_params] = pagination_params
    end

    if JSONAPI.configuration.top_level_meta_include_record_count
      options[:record_count] = record_count
    end

    JSONAPI::ResourcesOperationResult.new(:ok, resource_records, options)
  rescue JSONAPI::Exceptions::Error => e
    return JSONAPI::ErrorsOperationResult.new(e.errors[0].code, e.errors)
  end

  def record_count
    return super unless @resource_klass.should_query?(verified_filters)

    @resource_klass.search_count(verified_filters,
      context: @context,
      include_directives: @include_directives)
  end

  private

  def verified_filters
    @resource_klass.verify_filters(@filters, @context)
  end
end

# Enable callbacks in the processor
JSONAPI::OperationsProcessor.class_eval do
  define_jsonapi_resources_callbacks :search_operation
end
