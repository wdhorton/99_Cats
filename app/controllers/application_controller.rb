require 'byebug'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :current_session


  def current_user
    return nil unless current_session
    @current_user ||= current_session.user
  end


  def current_session
    return nil unless session[:session_token]
    @current_session ||= Session.find_by_session_token(session[:session_token])
  end

  def signed_in?
    !!current_user
  end

  def require_sign_in
  end

  def sign_in(user)
    user.reset_session_token!
    session[:session_token] = Session.last.session_token
  end

  def sign_out(user)
    user && current_session.destroy
    session[:session_token] = nil
  end

  private

    def check_if_signed_in
      (redirect_to cats_url) if signed_in?
    end

    def ensure_user_owns_cat
      request = CatRentalRequest.find(params[:id])
      if !current_user.cats.find(request.cat_id)
        redirect_to cats_url
      end
    end

end
