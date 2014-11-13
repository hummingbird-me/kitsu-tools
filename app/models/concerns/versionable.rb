module Versionable
  extend ActiveSupport::Concern

  def create_pending(author, object = {})
    # temp assign attributes
    self.assign_attributes(object)
    version = Version.new(
      item: self,
      user: author,
      object: self.attributes.merge(object),
      object_changes: self.changes
    )
    version.state = :pending
    version.save
  end

  def update_from_pending(version)
    attrs = self.attributes
    self.update_attributes(version.object)

    version.object = attrs
    version.state = :history
    version.save
  end
end
