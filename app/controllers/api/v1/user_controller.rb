class Api::V1::UserController < ApplicationController
    
    before_action :authenticate_user
    skip_before_action :authenticate_user, only: [:create, :confirm]
    before_action :set_user, only: [ :show, :update, :destroy ]
    rescue_from ActiveRecord::RecordNotFound, with: :notFound

    def index
        render json: { result: true, value: custom_data_users(User.all ) }, status: :ok
    end

    def create
        user = User.new(user_params)
        if user.save
            UserMailer.confirmation_email(user).deliver_now
            render json: { status: true, message: 'User created successfully', value: custom_data_user(user) }, status: :created
        else
            render json: { status: false, message: user.errors.full_messages }, status: :bad_request
        end
    end

    def show
        render json: { result: true, user: custom_data_user(@user) }, status: :ok
    end

    def update
        if @user.update(user_params)
            render json: { result: true, message: "Update Success", value: custom_data_user(@user) }, status: :ok
        else 
            render json: { result: false, message: @user.errors}, status: :unprocessable_entity
        end
    end

    def destroy
        if @user.destroy
            render json: { result: true, message: "Delete Success" }, status: :ok
        else
            render json: { result: false, message: @user.errors }
        end
    end
    
    def confirm    
        user = User.find_by(confirmation_token: params[:token].to_s)      
        if user.present? && user.confirmation_token_valid?
            user.mark_as_confirmed!
            render json: {status: true, message: 'Congratulations, account confirmed successfully'}, status: :ok
        else
            render json: {status: false, message: 'Invalid token'}, status: :bad_request
        end
    end
    
    private

    # def authenticate_user
    #     token, _option = token_and_options(request)
    #     user_id = AuthenticationTokenService.decode(token)
    #     User.find(user_id)
    #     rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
    #         render json: {result: false, message: e}, status: :unauthorized
    # end

    def notFound
        render json: { result: false, message: "Data Not Found" }, status: :not_found
    end

    def custom_data_users(users)
        users.map do |user|
            {
                id: user.id,
                name: user.name,
                username: user.username,
                email: user.email,
                role: user.role,
                confirmed_at: user.confirmed_at,
                joined_at: user.confirmation_sent_at
            }
        end
    end

    def custom_data_user(user)
        {
            id: user.id,
            name: user.name,
            username: user.username,
            email: user.email,
            role: role_name(user)
        } 
    end
    
    def set_user
        @user = User.find(params[:id])
    end
    
    def user_params
        params.permit(:name, :username, :email, :role, :password, :password_confirmation)
    end

    def role_name(user)
        (user.role == "1") ? 'Administrator' : (user.role == "2") ? 'Contributor' : 'Public'
    end
end
