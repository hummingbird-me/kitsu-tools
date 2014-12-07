module Versionable
  extend ActiveSupport::Concern

  def create_pending(author, object = {})
    comment = object.delete(:edit_comment)
    # temp assign attributes
    self.assign_attributes(object)
    version = Version.new(
      item: self,
      user: author,
      object: object,
      object_changes: self.changes,
      comment: comment
    )
    version.state = :pending
    version.save
    version
  end

  def update_from_pending(version)
    attrs = self.attributes.except(:id)
    self.update_attributes!(version.object)

    version.object = attrs
    version.state = :history
    version.save
  end
end
