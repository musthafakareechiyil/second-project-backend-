require 'jwt'

module JwtToken 
    extend ActiveSupport::Concern
    SECRET_KEY = Rails.application.secret_key_base
    
    def jwt_encode(payload, exp = 10.days.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, SECRET_KEY)
    end

    def jwt_decode(token)
        decoded = JWT.decode(token, SECRET_KEY)[0]
        ActiveSupport::HashWithIndifferentAccess.new(decoded)
    end

    def jwt_decode_rs256(token)
        decoded = JWT.decode(token, SECRET_KEY, false, algorithm: 'RS256')[0]
        ActiveSupport::HashWithIndifferentAccess.new(decoded)
    end
end