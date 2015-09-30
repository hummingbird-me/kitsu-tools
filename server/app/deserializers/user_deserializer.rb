class UserDeserializer < Deserializer
  model User
  key :id

  fields :name, :bio, :about, :avatar, :cover_image, :email, :password
  conditions cover_image: :data_uri?,
             avatar: :data_uri?,
             password: ->(p) { p.present? }

  def self.data_uri?(str)
    str.starts_with?('data:')
  end
end
