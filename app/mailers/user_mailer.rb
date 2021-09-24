class UserMailer < ApplicationMailer
    def confirmation_email(user)
        @user = user
        @url  = "http://localhost:3000/api/v1/user/confirm?token=#{@user.confirmation_token}"
        mail(
            to: @user.email, 
            subject: "Confirmation Signup: #{@user.email}"
        )
    end
end
