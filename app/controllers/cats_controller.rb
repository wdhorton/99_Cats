class CatsController < ApplicationController

    def index
      @cats = Cat.all
      render :index
    end

    def show
      @cat = Cat.find(params[:id])
      render :show
    end

    def new
      render :new
    end

    def create
      if (@cat = Cat.create(cat_params))
        render :show
      else
        render json: @cat.errors.full_messages
      end
    end

    def edit
      @cat = Cat.find(params[:id])
      render :edit
    end

    def update
      @cat = Cat.find(params[:id])
      if @cat.update(cat_params)
        render :show
      else
        render json: @cat.errors.full_messages
      end
    end

    private
      def cat_params
        params.require(:cat).permit(:birth_date, :color, :name, :sex, :description)
      end
end
