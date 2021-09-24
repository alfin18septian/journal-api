class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token
    
    private

    def current_user
        token, _option = token_and_options(request)
        user_id = AuthenticationTokenService.decode(token)
        User.find(user_id)
        rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
            render json: {result: false, message: e}, status: :unauthorized
    end
end
