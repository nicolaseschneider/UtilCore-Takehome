class UsersController < ApplicationController
    # GET /users
    def index
        users = User.all;
        render json: users
    end

    # POST /users
    def create
        user = User.new(user_params)
        if user.save
            render json: user, status: :created
        else
            render json: user.errors, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /users/:id
    def update
        user = User.find(params[:id])
        if user.update(user_params)
        render json: user
        else
        render json: user.errors, status: :unprocessable_entity
        end
    end

    # GET /users/:id
    def show
        user = User.find(params[:id])
        render json: user
    rescue ActiveRecord::RecordNotFound
        render json: { message: 'User not found' }, status: :not_found
    end

    # DELETE /users/:id
    def destroy
        user = User.find(params[:id])
        user.destroy
        head :no_content
    rescue ActiveRecord::RecordNotFound
        render json: { message: 'User not found' }, status: :not_found
    end

    private

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end
end
