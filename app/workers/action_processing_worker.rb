class ActionProcessingWorker
  def perform(action_id)
    action = Action.find action_id

    # Process the action. :P
    
    action.destroy
  end
end
