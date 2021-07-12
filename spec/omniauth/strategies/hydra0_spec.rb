require 'spec_helper'

def provider_name(klass)
  klass.to_s.split("::")[-1].downcase
end

[OmniAuth::Strategies::Hydra0].each{|provider|
  RSpec.describe provider do
    subject(:strategy) { described_class.new({}) }

    let(:access_token) { instance_double('AccessToken', :options => {}) }
    let(:parsed_response) { instance_double('ParsedResponse') }
    let(:response) { instance_double('Response', :parsed => parsed_response) }

    let(:development_site)          { 'http://localhost:9000/api/v3' }
    let(:development_authorize_url) { 'http://localhost:9000/login/oauth/authorize' }
    let(:development_token_url)     { 'http://localhost:9000/login/oauth/access_token' }

    let(:development) do
      described_class.new('RASPBERRY_KEY', 'RASPBERRY_SECRET',
                          :client_options => {
                            :site          => development_site,
                            :authorize_url => development_authorize_url,
                            :token_url     => development_token_url,
                          })
    end

    before(:each) do
      allow(strategy).to receive(:access_token).and_return(access_token)
    end

    context 'client options' do
      it 'has the correct site url' do
        expect(strategy.options.client_options.site).to eq('https://auth.raspberrypi.org')
      end

      it 'has the correct authorize url' do
        expect(strategy.options.client_options.authorize_url).to eq('https://auth.raspberrypi.org/oauth2/auth')
      end

      it 'has the correct token url' do
        expect(strategy.options.client_options.token_url).to eq('https://auth.raspberrypi.org/oauth2/token')
      end

      describe 'defaults are overrideable' do
        it 'for site' do
          expect(development.options.client_options.site).to eq(development_site)
        end

        it 'for authorize url' do
          expect(development.options.client_options.authorize_url).to eq(development_authorize_url)
        end

        it 'for token url' do
          expect(development.options.client_options.token_url).to eq(development_token_url)
        end
      end
    end

    context '#email' do
      it 'returns email from deserialised info if available' do
        allow(strategy).to receive(:raw_info).and_return('email' => 'you@example.com')
        expect(strategy.email).to eq('you@example.com')
        expect(strategy.info['email']).to eq('you@example.com')
      end

      it 'returns nil if there is no email in raw_info' do
        allow(strategy).to receive(:raw_info).and_return({})
        expect(strategy.email).to be_nil
        expect(strategy.info['email']).to be_nil
      end
    end

    context '#name' do
      it 'returns name from deserialised info if available' do
        allow(strategy).to receive(:raw_info).and_return({'name' => 'Jane Doe'})
        expect(strategy.fullname).to eq('Jane Doe')
        expect(strategy.info['name']).to eq('Jane Doe')
      end

      it 'returns nil if there is no name in raw_info' do
        allow(strategy).to receive(:raw_info).and_return({})
        expect(strategy.fullname).to be_nil
        expect(strategy.info['name']).to be_nil
      end
    end

    context '#nickname' do
      it 'returns nickname from deserialised info if available' do
        allow(strategy).to receive(:raw_info).and_return({'nickname' => 'Raspberry Jane'})
        expect(strategy.nickname).to eq('Raspberry Jane')
        expect(strategy.info['nickname']).to eq('Raspberry Jane')
      end

      it 'returns nil if there is no nickname in raw_info' do
        allow(strategy).to receive(:raw_info).and_return({})
        expect(strategy.nickname).to be_nil
        expect(strategy.info['nickname']).to be_nil
      end
    end

    context '#image' do
      it 'returns image from deserialised info if available' do
        allow(strategy).to receive(:raw_info).and_return({'picture' => '/profile/1234/avatar'})
        expect(strategy.image).to eq('/profile/1234/avatar')
        expect(strategy.info['image']).to eq('/profile/1234/avatar')
      end

      it 'returns nil if there is no picture in raw_info' do
        allow(strategy).to receive(:raw_info).and_return({})
        expect(strategy.image).to be_nil
        expect(strategy.info['image']).to be_nil
      end
    end      

    context '#extra' do
      it 'returns roles and picture from deserialised extra if available' do
        allow(strategy).to receive(:raw_info).and_return({'roles' => 'admin', 'picture' => '/profile/1234/avatar'})
        expect(strategy.extra['raw_info']['roles']).to eq('admin')
        expect(strategy.extra['raw_info']['picture']).to eq('/profile/1234/avatar')
      end

      it 'returns nil if no roles or picture in raw_info' do
        allow(strategy).to receive(:raw_info).and_return({})
        expect(strategy.extra['raw_info']['roles']).to be_nil
        expect(strategy.extra['raw_info']['picture']).to be_nil
      end
    end

    describe '#callback_url' do
      it 'is a combination of host and callback path' do
        allow(strategy).to receive(:full_host).and_return('https://example.com')
        strategy.instance_variable_set(:@env, {})

        expect(strategy.callback_url).to eq("https://example.com/auth/#{provider_name provider}/callback")
      end
    end
  end
}
