ApplicationController.class_eval do
  skip_before_action :ensure_correct_media_type
end
