require 'omniauth-oauth2'
require 'jwt'

module OmniAuth::Strategies
  class Hydra0 < OmniAuth::Strategies::OAuth2
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

    def build_access_token
       options.token_params[:headers] = { 'Authorization' => basic_auth_header }
       super
     end

    def basic_auth_header
     'Basic ' + Base64.strict_encode64("#{options[:client_id]}:#{options[:client_secret]}")
    end

    def callback_url
      full_host + callback_path
    end

    uid { raw_info['uuid'].to_s }

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

OmniAuth.config.add_camelization 'hydra0', 'Hydra0'
