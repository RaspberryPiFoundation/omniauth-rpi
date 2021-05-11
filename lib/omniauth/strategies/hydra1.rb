require 'omniauth-oauth2'
require 'jwt'

module OmniAuth::Strategies
  class Hydra1 < OmniAuth::Strategies::OAuth2
    option :client_options,
           :site          => 'https://auth1.raspberrypi.org',
           :authorize_url => 'https://auth1.raspberrypi.org/oauth2/auth',
           :token_url     => 'https://auth1.raspberrypi.org/oauth2/token'

    def authorize_params
      super.tap do |params|
        %w[scope client_options].each do |v|
          params[v.to_sym] = request.params[v] if request.params[v]
        end
      end
    end

    def callback_url
      full_host + callback_path
    end

    uid { raw_info['sid'].to_s }

    info do
      {
        'email'    => email,
        'username' => username,
        'name'     => fullname,
        'nickname' => nickname,
        'image'    => image,
      }
    end

    extra do
      {
        'raw_info' => raw_info
      }
    end

    extra do
      {
        'raw_info' => raw_info
      }
    end

    def raw_info
      @raw_info ||= (JWT.decode access_token.params['id_token'], nil, false)[0]
    end

    def email
      raw_info['email']
    end

    # <13 accounts have username instead of email
    def username
      raw_info['username']
    end

    def nickname
      raw_info['nickname']
    end

    # use fullname to avoid clash with 'name'
    def fullname
      raw_info['name']
    end

    def image
      # deserialise openid claim into auth schema
      raw_info['picture']
    end
  end
end

OmniAuth.config.add_camelization 'hydra1', 'Hydra1'
