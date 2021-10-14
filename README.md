# OmniAuth Raspberry Pi

This is the official OmniAuth strategy for authenticating to Raspberry Pi Accounts using Hydra v0 (for Hydra v1 see the `main` branch and `v1.x.x` releases).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "omniauth-rpi", git: "https://github.com/RaspberryPiFoundation/omniauth-rpi.git", tag: "v0.9.0"
```

And then execute:

    $ bundle

## Basic Usage

- [Integrating with OmniAuth](https://github.com/omniauth/omniauth/wiki)
- [Integrating with Devise](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview)


```ruby
use OmniAuth::Builder do
  provider OmniAuth::Strategies::Hydra0, ENV['RASPBERRY_KEY'], ENV['RASPBERRY_SECRET']
end
```

## Use in development

In development it is sometimes useful to point at a staging/local version of the authentication
server (ie Hydra).

```ruby
use OmniAuth::Builder do
  provider OmniAuth::Strategies::Hydra0, ENV['RASPBERRY_KEY'], ENV['RASPBERRY_SECRET'],
    :scope           => 'openid email profile',
    :client_options  => {
      :site          => 'http://localhost:9000',
      :authorize_url => 'http://localhost:9000/oauth2/auth',
      :token_url     => 'http://localhost:9000/oauth2/token'
    }
 )
```

## Bypassing OmniAuth/OAuth

It is also possible to bypass OmniAuth (and OAuth) **entirely**, which can be useful in circumstances where hostnames are dynamic, e.g. in review deployments.  To do this add the following code to your OmniAuth initializer.

```ruby
# We've usually used an environment variable set outside the app to trigger the
# auth bypass.
if ENV.has_key? 'BYPASS_OAUTH'
  using RpiAuthBypass
  OmniAuth.config.enable_rpi_auth_bypass
end
```

This will log you in with the following details:
  * uid: `b6301f34-b970-4d4f-8314-f877bad8b150`
  * email: `web@raspberrypi.org`
  * name: `Web Team`
  * nickname: `Web`

If you wish to specify your user's details, you can add the info manually with the following method call.
```
OmniAuth.config.add_rpi_mock(uid: '1234', info: {name: 'Example', nickname: 'Ex', email: 'ex@example.com' } )
```

All this could also be done inside the `OmniAuth::Builder` block too.

```ruby
using RpiAuthBypass

use OmniAuth::Builder do
  configure do |c|
    if ENV.has_key? 'BYPASS_OAUTH'
      c.enable_rpi_auth_bypass
      c.add_rpi_mock(uid: 'foo', info: {name: ... } )
    end
  end
end
```

## Publishing changes

When publishing changes to the provider, don't forget to bump the version number in `lib/omniauth-rpi/version.rb`
