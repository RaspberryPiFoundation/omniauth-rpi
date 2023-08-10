# frozen_string_literal: true

require 'jwt'

module OmniAuth::Strategies
  class Rpi < OmniAuth::Strategies::Hydra1
    option name: "raspberrypi_accounts"
  end
end

OmniAuth.config.add_camelization 'rpi', 'Rpi'
