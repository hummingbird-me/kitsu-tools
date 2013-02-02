class AdminController < ApplicationController
  http_basic_authenticate_with :name => "change", :password => "thislater"
  
  def index
    @quotes_pending_moderation = Quote.where("visible IS NULL OR visible = ?", false).includes(:anime, :creator)
  end

  def approve_quote
    @quote = Quote.find(params[:id])
    @quote.visible = true
    @quote.save
    redirect_to admin_panel_path
  end

  def delete_quote
    @quote = Quote.find(params[:id])
    @quote.delete
    redirect_to admin_panel_path
  end
end
