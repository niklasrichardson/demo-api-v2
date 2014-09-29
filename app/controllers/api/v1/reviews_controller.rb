module Api
  module V1
    class ReviewsController < ApplicationController
      
      def index
        @reviews = Review.where(:user_id => user_id).all
        render json: @reviews
      end

      def show
        @review = Review.where(id: params[:id]).where(:user_id => user_id)
        render json: @review
      end
      
      def create
        review = review_params
        review["user_id"] = user_id
        @review = Review.new(review)

        if @review.save
          render json: @review, status: :created, location: api_v1_review_url(@review)
        else
          render json: @review.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @review = Review.where(:id => params[:id]).where(:user_id => user_id).first
        @review.destroy
        head :ok
      end

      private

      def review_params
        params.permit(:title, :body, :rating, :user_id)
      end

      def user_id
        request.env[:user_id]
      end
    end
  end
end