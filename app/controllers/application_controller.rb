require 'byebug'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user


  def current_user
    # debugger
    return nil unless session[:session_token]

    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def signed_in?
    !!current_user
  end

  def require_sign_in
  end

  def sign_in(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def sign_out(user)
    user && user.reset_session_token!
    session[:session_token] = nil
  end

  private

    def check_if_signed_in
      (redirect_to cats_url) if signed_in?
    end

    def ensure_user_owns_cat
      if !current_user.cats.find(param[:id])
        redirect_to cats_url
      end
    end

end
