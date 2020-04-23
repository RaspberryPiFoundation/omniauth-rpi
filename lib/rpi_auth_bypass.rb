# frozen_string_literal: true

module RpiAuthBypass
  DEFAULT_UID = 'b6301f34-b970-4d4f-8314-f877bad8b150'
  DEFAULT_EMAIL = 'web@raspberrypi.org'
  DEFAULT_NAME = 'Web Team'
  DEFAULT_NICKNAME = 'Web'
  DEFAULT_INFO = {
    name: DEFAULT_NAME,
    nickname: DEFAULT_NICKNAME,
    email: DEFAULT_EMAIL
  }.freeze

  refine OmniAuth::Configuration do
    def enable_rpi_auth_bypass
      logger.info 'Enabling RpiAuthBypass'
      add_rpi_mock unless @mock_auth[:rpi]

      self.test_mode = self.rpi_auth_bypass = true
    end

    def disable_rpi_auth_bypass
      logger.debug 'Disabing RpiAuthBypass'
      @mock_auth.delete(:rpi)

      self.test_mode = self.rpi_auth_bypass = false
    end

    def add_rpi_mock(uid: RpiAuthBypass::DEFAULT_UID, info: RpiAuthBypass::DEFAULT_INFO)
      add_mock(:rpi, {
                 provider: 'Rpi',
                 uid: uid,
                 info: info
               })
    end

    attr_writer :rpi_auth_bypass
  end
end
