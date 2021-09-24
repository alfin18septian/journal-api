class UserMailer < ApplicationMailer
    def confirmation_email(user)
        @user = user
        @token  = @user.confirmation_token
        mail(
            to: @user.email, 
            subject: "Confirmation Signup: #{@user.email}"
        )
    end
    def confirmation_reset_password(user)
        @user = user
        @token  = @user.reset_password_token
        mail(
            to: @user.email, 
            subject: "Reset Password Confirmation"
        )
    end
end
