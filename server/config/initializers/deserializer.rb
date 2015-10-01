require 'deserializer'

deserializers_path = "#{Rails.root}/app/deserializers"
unless ActiveSupport::Dependencies.autoload_paths.include?(deserializers_path)
  ActiveSupport::Dependencies.autoload_paths << deserializers_path
end
