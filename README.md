# OmniAuth Raspberry Pi

This is the official OmniAuth strategy for authenticating to Raspberry Pi Accounts using Hydra v1 (for Hydra v0 see the `hydra-v0` branch and `v0.x.x` releases).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-rpi',
    git: 'https://github.com/RaspberryPiFoundation/omniauth-rpi.git',
    tag: 'v1.3.2'
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

## v1 Signup redirects

When a client application using Hydra v1 redirects to Pi Accounts / Profile to have a user sign up (either through the default login route with the user then opting to create an account, or through forcing signup (below)), it is necessary to set the `v1_signup` value in the `login_options` param:

```
POST /auth/rpi?login_options=v1_signup
```

This ensures that once the `/signup` route has been requested, upon a successful submission of verification code or token to the `/verify` endpoint, the browser is redirected to `/v1/login` so that the remainder of the auth flow can be completed, signing the user in with Hydra and redirecting back to the client application correctly (rather than just dumping the user at their Profile dashboard).

**Note:** Whilst Hydra v0 routes are still the default in Pi Accounts / Profile, `?login_options=v1_signup` needs to be set for any login path, regardless of whether `force_signup` is also being set, this is to cover cases where a user clicks a log in link but then at the log in UI clicks the create account link instead of logging in.

For the full documentation see: https://digital-docs.rpf-internal.org/docs/codebases/accounts/profile-app/hydra-v1-signup

## Forcing sign up flow

It's possible to force a redirect to the Pi Accounts sign up page (rather than the default log in page) through:

```
POST /auth/rpi?login_options=force_signup
```

(multiple options can be comma-separated, eg. `?login_options=v1_signup,force_signup`)

For the full documentation see: https://digital-docs.rpf-internal.org/docs/codebases/accounts/profile-app/force-signup

## Testing

Run:

```
rspec
```

## Publishing changes

https://rubygems.org/gems/omniauth-rpi

When publishing changes to the provider, don't forget to bump the version number in `lib/omniauth-rpi/version.rb` and update `CHANGELOG.md` accordingly.

```
rake build
gem push pkg/omniauth-rpi-x.x.x.gem
```

(how to publish to Rubygems: https://guides.rubygems.org/publishing/#publishing-to-rubygemsorg)
