class AuthenticationTokenService
    HMAC_SECRET = 'FutGs65LaULWmSumMLXe8S3ioc4Y4RH2aSiJ2X-2eks'
    ALGORYTHM_TYPE = 'HS256'

    def self.call(user_id)
        valid_for_minutes = 60
        exp = Time.now.to_i + (valid_for_minutes*60)
        payload = {
            "exp": exp,
            user_id: user_id
        }

        JWT.encode payload, HMAC_SECRET, ALGORYTHM_TYPE
    end

    def self.decode(token)
        decoded_token = JWT.decode token, HMAC_SECRET, true, { algorithm: ALGORYTHM_TYPE }
        decoded_token[0]['user_id']
    end
    
end