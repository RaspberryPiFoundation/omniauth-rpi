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
  provider :rpi, ENV['RASPBERRY_KEY'], ENV['RASPBERRY_SECRET']
end
```
