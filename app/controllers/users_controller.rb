class UsersController < ApplicationController
    wrap_parameters format: []
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    def create
        if params[:password] == params[:password_confirmation]
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user
        else
        render json: {error: "Password does not match"}, status: :unprocessable_entity
        end
    end

    def show
        user = User.find_by(id: session[:user_id])
        if user
        render json: user
        else  
        render json: {error: "No user logged in"}, status: :unauthorized
        end
    end

    private

    def render_unprocessable_entity(invalid)
        render json:{error: invalid.record.errors}, status: :unprocessable_entity
    end

    def user_params
        params.permit(:username, :password)
    end
end
