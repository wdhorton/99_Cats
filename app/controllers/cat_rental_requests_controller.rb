class CatRentalRequestsController < ApplicationController

  def index
    @requests = CatRentalRequest.all
    render :index
  end

  def show
    @request = CatRentalRequest.find(params[:id])
    render :show
  end

  def update
  end

  def edit
  end

  def destroy
  end

  def new
    @cats = Cat.all
    render :new
  end

  def create
    @request = CatRentalRequest.new(cat_request_params)
    if @request.save
      render :show
    else
      render json: @request.errors.full_messages
    end
  end

  def approve
    @request = CatRentalRequest.find(params[:id])
    @request.approve!
    redirect_to cat_url(@request.cat_id)
  end

  private

    def cat_request_params
      params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
    end

end
