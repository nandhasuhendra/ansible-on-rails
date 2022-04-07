class JsonWebToken
  HMAC_SECRET = Rails.application.credentials.secret_key_base

  def self.encode(payload, expired = 45.minutes.from_now)
    payload[:exp] = expired.to_i

    JWT.encode(payload, HMAC_SECRET, 'HS256')
  end

  def self.decode(token)
    body = JWT.decode(token, HMAC_SECRET, true, { algorithm: 'HS256' })[0]

    HashWithIndifferentAccess.new body
  rescue JWT::DecodeError => e
    raise ErrorHandler::InvalidToken, e.message
  end
end
