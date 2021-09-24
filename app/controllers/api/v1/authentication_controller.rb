class Api::V1::AuthenticationController < ApplicationController
    class AuthenticationError < StandardError; end
    class VerificationError < StandardError; end

    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from AuthenticationError, with: :handle_anauthenticated
    rescue_from VerificationError, with: :handle_unverified

    def create
        raise AuthenticationError unless user = User.find_by(username: params.require(:username))
        raise AuthenticationError unless user.authenticate(params.require(:password))
        raise VerificationError unless user.confirmed_at?
        
        token = AuthenticationTokenService.call(user.id)
        render json: { status: true, token: token }, status: :ok
    end

    private

    def parameter_missing(e)
        render json: { status: false, message: e.message }, status: :unprocessable_entity
    end

    def handle_anauthenticated
        render json: {status: false, message: 'Invalid username / password'}, status: :unauthorized
    end

    def handle_unverified
        render json: {status: false, message: 'Email not verified' }, status: :unauthorized
    end
    
end
