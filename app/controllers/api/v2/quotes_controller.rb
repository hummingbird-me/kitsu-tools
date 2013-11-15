module Api::V2
  class QuotesController < ApiController
    def update
      quote = Quote.find(params[:id])

      # Update favorite status.
      if params[:quote]["is_favorite"]
        quote.add_or_update_evaluation(:votes, 1, current_user)
        Substory.from_action({
          user_id: current_user.id,
          action_type: "liked_quote",
          quote_id: quote.id,
          time: Time.now
        })
      else
        quote.delete_evaluation(:votes, current_user)
        Substory.from_action({
          user_id: current_user.id,
          action_type: "unliked_quote",
          quote_id: quote.id,
          time: Time.now
        })
      end

      render json: quote
    end
  end
end
