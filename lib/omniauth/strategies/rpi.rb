require 'omniauth-oauth2'
require 'jwt'

module OmniAuth
  module Strategies
    class Rpi < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://auth.raspberrypi.org',
        :authorize_url => 'https://auth.raspberrypi.org/oauth2/auth',
        :token_url => 'https://auth.raspberrypi.org/oauth2/token'
      }

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            params[v.to_sym] = request.params[v] if request.params[v]
          end
        end
      end

      def build_access_token
        options.token_params.merge!(:headers => {'Authorization' => basic_auth_header })
        super
      end

      def basic_auth_header
        "Basic " + Base64.strict_encode64("#{options[:client_id]}:#{options[:client_secret]}")
      end

      def callback_url
        full_host + callback_path
      end

      uid { raw_info['uuid'].to_s }

      info do
        {
          'email' => email,
          'nickname' => nickname,
          'name' => fullname
        }
      end

      def raw_info
        @raw_info ||= (JWT.decode access_token.params["id_token"], nil, false)[0]
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
end

OmniAuth.config.add_camelization 'rpi', 'Rpi'
