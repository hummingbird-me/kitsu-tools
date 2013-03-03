class BetaInvitesController < ApplicationController
  def index
    if params[:email].nil?
      redirect_to new_beta_invite_path
    else
      @beta_invite = BetaInvite.find_by_email(params[:email])
      @people_before_you = @beta_invite.id
    end
  end
  
  def new
  end
  
  def create
    # Check whether there already is a beta invite by this name.
    email = params["beta_invite"]["email"]
    if (beta_invite = BetaInvite.find_by_email(email)).nil?
      beta_invite = BetaInvite.create(email: email)
      BetaMailer.delay.beta_sign_up(beta_invite) if BetaInvite.find_by_email(email)
    end
    beta_invite = BetaInvite.find_by_email(email)
    redirect_to beta_invites_path(email: email)
  end
end
