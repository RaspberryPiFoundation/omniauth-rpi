# frozen_string_literal: true

require 'omniauth/openid_connect'
require 'jwt'

module OmniAuth
  module Strategies
    class Hydra1 < OmniAuth::Strategies::OpenIDConnect
      option :issuer,   'https://auth-v1.raspberrypi.org/'
      option :uid_field, 'sub'
      option :client_options, {
        discovery: true,
        host: 'auth-v1.raspberrypi.org',
      }

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
end

OmniAuth.config.add_camelization 'hydra1', 'Hydra1'
