# frozen_string_literal: true

require 'omniauth'

module RpiOmniauthBypass
  DEFAULT_UID = 'b6301f34-b970-4d4f-8314-f877bad8b150'
  DEFAULT_EMAIL = 'web@raspberrypi.org'
  DEFAULT_NAME = 'Web Team'
  DEFAULT_NICKNAME = 'Tester'
  DEFAULT_INFO = {
    name: DEFAULT_NAME,
    nickname: DEFAULT_NICKNAME,
    email: DEFAULT_EMAIL
  }.freeze

  refine OmniAuth::Configuration do
    def enable_rpi_omniauth_bypass
      logger.info 'Enabling RpiOauthBypass'
      add_rpi_mock unless @mock_auth[:rpi]

      self.test_mode = self.rpi_omniauth_bypass = true
    end

    def disable_rpi_omniauth_bypass
      logger.debug 'Disabing RpiOauthBypass'
      @mock_auth.delete(:rpi)

      self.test_mode = self.rpi_omniauth_bypass = false
    end

    def add_rpi_mock(uid: RpiOmniauthBypass::DEFAULT_UID, info: RpiOmniauthBypass::DEFAULT_INFO)
      add_mock(:rpi, {
                 provider: 'Rpi',
                 uid: uid,
                 info: info
               })
    end

    attr_writer :rpi_omniauth_bypass
  end

  refine OmniAuth::Strategy do
    def setup_phase
      log :info, 'Using RpiOauthBypass' if config.rpi_omniauth_bypass
      super
    end
  end
end
