module OmniAuth::Strategies
  class RpiFake
    include OmniAuth::Strategy

    option :uid, 'b6301f34-b970-4d4f-8314-f877bad8b150'
    option :email, 'web@raspberrypi.org'
    option :nickname, 'Web'
    option :name, 'Web Team'

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
