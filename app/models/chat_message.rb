class ChatMessage
  include Mongoid::Document

  field :user_id, type: Integer
  field :message_type, type: String
  field :message, type: String
  field :created_at, type: Time, default: ->{ Time.now }
  field :formatted_message, type: String

  index "created_at" => -1
end
