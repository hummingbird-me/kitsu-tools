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
end
