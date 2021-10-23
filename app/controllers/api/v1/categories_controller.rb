class Api::V1::CategoriesController < ApplicationController
    
    before_action :set_category, only: [ :show, :update, :destroy ]
    rescue_from ActiveRecord::RecordNotFound, with: :notFound

    def index
        render json: { result: true, value: Category.all }, status: :ok
    end

    def create
        category = Category.new(category_params)
        if category.save
            render json: { result: true, message: 'Created Success', value: category }, status: :created
        else
            render json: { result: false, message: category.errors.full_messages }, status: :bad_request
        end
    end

    def show
        render json: { result: true, value: @category }, status: :ok
    end
    
    def update
        if @category.update(category_params)
            render json: { result: true, message: "Update Success", value: @category }, status: :ok
        else 
            render json: { result: false, message: @category.errors}, status: :unprocessable_entity
        end
    end

    def destroy
        if @category.destroy
            render json: { result: true, message: "Delete Success" }, status: :ok
        else
            render json: { result: false, message: @category.errors }
        end
    end

    private

    def notFound
        render json: { result: false, message: "Data Not Found" }, status: :not_found
    end

    def category_params
        params.permit(:category)
    end
    
    def set_category
        @category = Category.find(params[:id])
    end
end
