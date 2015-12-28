require_dependency 'jsonapi/search_operation'

class SearchableRequest < JSONAPI::Request
  def add_find_operation
    # Default sort is by {_score: :desc}
    @sort_criteria = [{field: '_score', direction: :desc}] unless params[:sort]

    @operations.push SearchOperation.new(
      @resource_klass,
      context: @context,
      filters: @filters,
      include_directives: @include_directives,
      sort_criteria: @sort_criteria,
      paginator: @paginator
    )
  end
end
