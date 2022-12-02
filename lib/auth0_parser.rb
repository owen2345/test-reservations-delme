# frozen_string_literal: true

# rubocop:disable Style/ClassVars
# INFO: Copy from Auth0
class Auth0Parser
  ExpiredToken = Class.new(StandardError)
  @@jwks_keys = nil
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def self.call(token)
    new(token).call
  end

  # @return (see User.from_token_data)
  def call
    check_expiration
    token_data
  end

  private

  def token_details
    @token_details ||= decode_token.first
  end

  def check_expiration
    time = Time.at(token_details['exp']) # rubocop:disable Rails/TimeZone
    time <= Time.current ? raise(ExpiredToken, 'Session expired') : nil
  end

  def token_data
    {
      email: token_details['https://buddy.buddyandselly.com/email'],
      name: token_details['nickname'],
      roles: token_details['https://buddy.buddyandselly.com/roles']
    }
  end

  # :nocov:
  def decode_token
    JWT.decode(token, nil,
               true, # Verify the signature of this token
               algorithms: 'RS256',
               iss: "https://#{ENV['AUTH0_DOMAIN']}/",
               verify_iss: true,
               aud: "https://#{ENV['AUTH0_DOMAIN']}/api/v2/",
               verify_aud: false) do |header|
      jwks_hash[header['kid']]
    end
  end

  def jwks_hash # rubocop:disable Metrics/MethodLength
    uri = "https://#{ENV['AUTH0_DOMAIN']}/.well-known/jwks.json"
    @@jwks_keys ||= Array(JSON.parse(Net::HTTP.get(URI(uri)))['keys'])
    Hash[
      @@jwks_keys.map do |k|
        [
          k['kid'],
          OpenSSL::X509::Certificate.new(
            Base64.decode64(k['x5c'].first)
          ).public_key
        ]
      end
    ]
  end
  # :nocov:
end
# rubocop:enable  Style/ClassVars
