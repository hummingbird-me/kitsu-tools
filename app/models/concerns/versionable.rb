module Versionable
  extend ActiveSupport::Concern

  IGNORED_ATTRS = %w(id created_at updated_at)

  def create_pending(author, object = {})
    comment = object.delete(:edit_comment)
    # temp assign attributes
    self.assign_attributes(object)
    # don't create the version if there was a validation error
    version = Version.new(
      item: self,
      user: author,
      object: object,
      object_changes: self.changes,
      comment: comment
    )
    version.state = :pending
    version.save if self.errors.blank?
    version
  end

  def update_from_pending(version)
    # when updating from a version as an admin, the record instance
    # is the same, so it is still dirty from the `assign_attributes`
    # method call in the `create_pending` method.
    self.reload if self.changed?

    attrs = self.attributes.except!(*IGNORED_ATTRS)
    self.update_attributes!(version.object)

    version.object = attrs
    version.state = :history
    version.save
  end

  def restore_to_version(version)
    return unless version.history?
    self.update_attributes!(version.object)
    # we are restoring to a past version, so delete this version
    # and any other versions ahead of this
    Version.where(state: Version.states[:history], item: self)
      .where("id >= ?", version.id).destroy_all
  end
end
