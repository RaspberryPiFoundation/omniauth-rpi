# OmniAuth Raspberry Pi

This is the official OmniAuth strategy for authenticating to Raspberry Pi Accounts using Hydra v1 (for Hydra v0 see the `hydra-v0` branch and `v0.x.x` releases).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-rpi',
    git: 'https://github.com/RaspberryPiFoundation/omniauth-rpi.git',
    tag: 'v1.3.1'
```

And then execute:

    $ bundle

## Usage with OmniAuth

- [Integrating with OmniAuth](https://github.com/omniauth/omniauth/wiki)

In `config/initializers/omniauth.rb`:

```ruby
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    OmniAuth::Strategies::Rpi, ENV['AUTH_CLIENT_ID'], ENV['AUTH_CLIENT_SECRET'],
    scope: 'openid email profile force-consent',
    callback_path: '/auth/callback',
    client_options: {
      site: ENV['AUTH_URL'],
      authorize_url: "#{ENV['AUTH_URL']}/oauth2/auth",
      token_url: "#{ENV['AUTH_URL']}/oauth2/token"
    },
    authorize_params: {
      brand: '<brand>'
    }
  )

  OmniAuth.config.on_failure = AuthController.action(:failure)
end
```

(the `Rpi` strategy extends the `Hydra1` strategy)

## Usage with Devise

- [Integrating with Devise](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview)

## Use in development

In development it is sometimes useful to point at a staging/local version of the authentication
server (ie. Hydra).

```ruby
:client_options  => {
  :site          => 'http://localhost:9000',
  :authorize_url => 'http://localhost:9000/oauth2/auth',
  :token_url     => 'http://localhost:9000/oauth2/token'
}
```

## Bypassing OmniAuth/OAuth

It is also possible to bypass OmniAuth (and OAuth) entirely which can be useful in circumstances where hostnames are dynamic, e.g. in review deployments, as well as in development. To do this add the following code to your OmniAuth initializer:

```ruby
# Use an environment variable set outside the app to trigger the auth bypass
if ENV['BYPASS_OAUTH'].present?
  using RpiAuthBypass
  OmniAuth.config.enable_rpi_auth_bypass
end
```

This will log you in with the following details:
  * uuid: `b6301f34-b970-4d4f-8314-f877bad8b150`
  * email: `web@raspberrypi.org`
  * name: `Web Team`
  * nickname: `Web`

If you wish to specify your user's details, you can add the info manually:

```ruby
if ENV['BYPASS_OAUTH'].present?
  using RpiAuthBypass
  OmniAuth.config.add_rpi_mock(
    uid: 'b6301f34-b970-4d4f-8314-f877bad8b150',
    info: {
      email: 'web@raspberrypi.org',
      name: 'Digital Products Team',
      nickname: 'DP',
      image: 'https://static.raspberrypi.org/files/accounts/default-avatar.jpg'
    },
    extra: {
      raw_info: {
        name: 'Digital Products Team',
        nickname: 'DP',
        email: 'web@raspberrypi.org',
        country: 'United Kingdom',
        country_code: 'GB',
        postcode: 'CB1 1AA',
        picture: 'https://static.raspberrypi.org/files/accounts/default-avatar.jpg',
        profile: 'https://my.raspberrypi.org/not/a/real/path'
      }
    }
  )
  OmniAuth.config.enable_rpi_auth_bypass
end
```

## Forcing sign up flow

It's possible to force a redirect to the Pi Accounts sign up page (rather than the default log in page) through:

```
POST /auth/rpi?login_options=force_signup
```

For the full documentation see: https://github.com/RaspberryPiFoundation/documentation/blob/main/accounts/force-signup.md

## Testing

Run:

```
rspec
```

## Publishing changes

When publishing changes to the provider, don't forget to bump the version number in `lib/omniauth-rpi/version.rb` and update `CHANGELOG.md` accordingly.
