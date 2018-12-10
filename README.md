# OmniAuth Raspberry Pi

This is the official OmniAuth strategy for authenticating to Raspberry pi.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth_rpi', :git => 'git@github.com:RaspberryPiFoundation/omniauth-rpi.git'
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
