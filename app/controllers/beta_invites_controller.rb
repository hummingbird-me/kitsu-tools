class BetaInvitesController < ApplicationController
  before_filter :redirect_to_sign_up
  def redirect_to_sign_up
    redirect_to '/users/sign_up'
  end

  def unsubscribe
    if params[:u]
      @beta_invite = BetaInvite.find_by_encrypted_email params[:u].downcase
      if @beta_invite
        @beta_invite.update_column :subscribed, false
        render :text => "You have been unsubscribed. (#{@beta_invite.email})"
        return
      end
    end
    redirect_to "/"
  end

  def index
    if params[:email].nil?
      redirect_to new_beta_invite_path
    else
      @beta_invite = BetaInvite.find_by_email(params[:email].downcase)
    end
  end
  
  def new
  end

  def invite_code
    valid_codes = %w[ACEN2013 ANICHARTNET THEFAN ANIMESUGGEST]
    email = params[:email].strip.downcase
    code = params[:invite_code].strip.upcase
    
    if valid_codes.include? code
      beta_invite = BetaInvite.find_by_email(email)
      beta_invite.invite!
      flash[:success] = "You have been invited to the beta!"
      mixpanel.track "Used Invite Code", {email: email, code: code} if Rails.env.production?
    else
      flash[:error] = "Sorry, #{code} is not a valid invite code."
    end

    redirect_to beta_invites_path(email: email)
  end
  
  def create
    # Check whether there already is a beta invite by this name.
    email = params["beta_invite"]["email"].downcase
    if (beta_invite = BetaInvite.find_by_email(email)).nil?
      beta_invite = BetaInvite.create(email: email, encrypted_email: SecureRandom.hex)
      BetaMailer.delay.beta_sign_up(beta_invite) if BetaInvite.find_by_email(email)
      finished("footer_ad_on_guest_homepage")
      mixpanel.track "Requested Invite", {email: email} if Rails.env.production?
    end
    beta_invite = BetaInvite.find_by_email(email)
    redirect_to beta_invites_path(email: email)
  end
  
  def resend_invite
    email = params["email"].downcase
    beta_invite = BetaInvite.find_by_email(email)
    if beta_invite.nil?
      redirect_to new_beta_invite_path
    else
      if beta_invite.invited?
        BetaMailer.delay.beta_invite(beta_invite)
        flash[:notice] = "The email has been resent."
      end
      redirect_to :back
    end
  end
end
