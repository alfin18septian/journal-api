class Api::V1::PasswordsController < ApplicationController
  def forgot
    if params[:email].blank?
      return render json: { status: false, message: "Email not present" }
    end

    user = User.find_by(email: params[:email].downcase)
    if user.present? && user.confirmed_at?
      user.generate_password_token!
      UserMailer.confirmation_reset_password(user).deliver_now
      render json: { status: true, message: "Reset Password Token has been sent to your email." }, status: :ok
    else
      render json: { status: false, message: ["Email address not found. Please check and try again."] }, status: :not_found
    end
  end

  def reset
    token = params[:token].to_s

    if params[:token].blank?
      return render json: { status: false, message: "Token not present" }
    end

    user = User.find_by(reset_password_token: token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        token = AuthenticationTokenService.call(user.id)
        render json: { status: true, message: "Reset password success" }, status: :ok
      else
        render json: { status: false, message: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { status: false, message: ["Link not valid or expired. Try generating a new link."] }, status: :not_found
    end
  end

  def update
    if !params[:password].present?
      render json: {status: false, message: 'Password not present'}, status: :unprocessable_entity
      return
    end
  
    if current_user.reset_password!(params[:password])
      render json: {status: true, message: "Update password success"}, status: :ok
    else
      render json: {status: false, messages: current_user.errors.full_messages}, status: :unprocessable_entity
    end
  end
end
