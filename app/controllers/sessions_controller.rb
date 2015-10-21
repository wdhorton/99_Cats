class SessionsController < ApplicationController
  before_action :check_if_signed_in, only: [:new, :create]

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
      )

    if user
      sign_in(user)
      redirect_to cats_url
    else
      flash.now[:errors] = user.errors.full_messages
      render :new
    end
  end

  def destroy
    sign_out(current_user)
    redirect_to new_session_url
  end

end
