class UsersController < ApplicationController
  before_action :check_if_signed_in, only: [:new, :create]

  def new
    render :new
  end

  def create
    @request = User.new(user_params)
    if @request.save
      redirect_to cats_url
    else
      flash.now[:errors] = @request.errors.full_messages
      render :new
  end

end
