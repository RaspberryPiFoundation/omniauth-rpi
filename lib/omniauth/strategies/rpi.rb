require 'omniauth-oauth2'
require 'jwt'

module OmniAuth::Strategies
  class Rpi < OmniAuth::Strategies::Hydra0
  end
end

OmniAuth.config.add_camelization 'rpi', 'Rpi'
