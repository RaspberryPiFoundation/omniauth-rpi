module OmniAuth::Strategies
  class RpiFake
    include OmniAuth::Strategy

    DEFAULT_UID = 'b6301f34-b970-4d4f-8314-f877bad8b150'
    DEFAULT_EMAIL = 'web@raspberrypi.org'
    DEFAULT_NAME = 'Web Team'
    DEFAULT_NICKNAME = 'Web'

    option :uid, DEFAULT_UID
    option :email, DEFAULT_EMAIL
    option :name, DEFAULT_NAME
    option :nickname, DEFAULT_NICKNAME

    uid { options.uid }

    info  do
      {
        'email' => options.email,
        'nickname' => options.nickname,
        'name' => options.name
      }
    end
    def email
      options.email
    end

    def nickname
      options.nickname
    end

    def name
      pp options
      options.name
    end

    alias fullname name
  end
end

OmniAuth.config.add_camelization 'rpi_fake', 'RpiFake'
