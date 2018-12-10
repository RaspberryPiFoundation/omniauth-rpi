require 'omniauth-oauth2'
require 'jwt'

module OmniAuth::Strategies
  class Hydra1 < OmniAuth::Strategies::OAuth2
    option :client_options,
           :site          => 'https://auth.raspberrypi.org',
           :authorize_url => 'https://auth.raspberrypi.org/oauth2/auth',
           :token_url     => 'https://auth.raspberrypi.org/oauth2/token'

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

    uid { raw_info['uuid'].to_s }

    info do
      {
        'email'    => email,
        'nickname' => nickname,
        'name'     => fullname,
      }
    end

    def raw_info
      @raw_info ||= (JWT.decode access_token.params['id_token'], nil, false)[0]
    end

    def email
      raw_info['email']
    end

    def nickname
      raw_info['nickname']
    end

    def fullname
      raw_info['name']
    end
  end
end

OmniAuth.config.add_camelization 'hydra1', 'Hydra1'
