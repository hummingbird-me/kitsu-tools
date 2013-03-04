require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminInvite
end

module RailsAdmin
  module Config
    module Actions
      class Invite < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :bulkable? do
          true
        end
        
        register_instance_option :controller do
          Proc.new do
            # Get all selected rows.
            @objects = list_entries(@model_config, :destroy)
                          .select {|x| not x.invited? }
            
            # Invite everyone.
            @objects.each {|x| x.invite! }

            flash[:success] = "Successfully invited #{@objects.length} users."
            
            redirect_to back_or_index
          end
        end
      end
    end
  end
end
