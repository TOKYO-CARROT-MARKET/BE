class JwtService
  ALGORITHM = "HS256"
  ACCESS_EXPIRY = 15.minutes
  REFRESH_EXPIRY = 30.days

  def self.encode_access(payload)
    encode(payload.merge(type: "access"), ACCESS_EXPIRY)
  end

  def self.encode_refresh(payload)
    encode(payload.merge(type: "refresh"), REFRESH_EXPIRY)
  end

  def self.decode_access(token)
    decoded = decode(token)
    return nil unless decoded && decoded[:type] == "access"
    decoded
  end

  def self.decode_refresh(token)
    decoded = decode(token)
    return nil unless decoded && decoded[:type] == "refresh"
    decoded
  end

  class << self
    private

    def secret
      ENV.fetch("JWT_SECRET_KEY")
    end

    def encode(payload, expiry)
      payload = payload.merge(exp: expiry.from_now.to_i)
      JWT.encode(payload, secret, ALGORITHM)
    end

    def decode(token)
      return nil unless token
      decoded = JWT.decode(token, secret, true, { algorithm: ALGORITHM })
      decoded[0].with_indifferent_access
    rescue JWT::DecodeError
      nil
    end
  end
end
