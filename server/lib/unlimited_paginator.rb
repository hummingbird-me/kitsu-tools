# I am the bone of my paginator
# Steel is my body and fire is my blood
# I have created over a thousand pages
# Unknown to Death, Nor known to Life
# Have withstood pain to create many pages
# Yet, those hands will never hold anything
# So as I pray, unlimited pagination works

class UnlimitedPaginator < OffsetPaginator
  private

  def verify_pagination_params
    if @limit < 1
      raise JSONAPI::Exceptions::InvalidPageValue.new(:limit, @limit)
    end

    if @offset < 0
      raise JSONAPI::Exceptions::InvalidPageValue.new(:offset, @offset)
    end
  end
end
