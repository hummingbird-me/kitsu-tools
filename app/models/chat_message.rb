class ChatMessage
  include Mongoid::Document

  field :user_id, Integer
  field :message_type, String
  field :message, String
end
