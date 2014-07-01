# https://github.com/jrgifford/delayed_paperclip/blob/master/lib/delayed_paperclip/attachment.rb#L94
# delayed_paperclip uses ActiveRecord::Relation#update_all which does not invoke 
# ActiveRecord callbacks such as after_save, this patch changes the update method
# to use ActiveRecord::Relation#update, so avatar syncing is working as intended.

module DelayedPaperclip
  module Attachment
    module InstanceMethods
      private
      def update_processing_column
        if instance.respond_to?(:"#{name}_processing?")
          instance.send("#{name}_processing=", false)
          instance.class.update(instance.id, { "#{name}_processing" => false })
        end
      end
    end
  end
end
