module FriendlyShow
  extend ActiveSupport::Concern

  def show
    if params[:id] =~ /\D+/
      begin
        redirect_to resource_klass._model_class.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        e = JSONAPI::Exceptions::RecordNotFound.new(params[:id])
        handle_exceptions(e)
      end
    else
      super
    end
  end
end
