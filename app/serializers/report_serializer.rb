class ReportSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id,
             :reason,
             :comments,
             :status

  has_one :reporter, embed_key: :name
  has_one :reportable, polymorphic: true, include: true
end
