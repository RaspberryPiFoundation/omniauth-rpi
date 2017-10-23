require 'spec_helper'

RSpec.describe OmniAuth::Strategies::Rpi do
  let(:access_token) { instance_double('AccessToken', :options => {}) }
  let(:parsed_response) { instance_double('ParsedResponse') }
  let(:response) { instance_double('Response', :parsed => parsed_response) }

  subject do
    OmniAuth::Strategies::Rpi.new({})
  end

  before(:each) do
    allow(subject).to receive(:access_token).and_return(access_token)
  end

  context 'client options' do
    it 'should have correct site' do
      expect(subject.options.client_options.site).to eq('https://auth.raspberrypi.org')
    end

    it 'should have correct authorize url' do
      expect(subject.options.client_options.authorize_url).to eq('https://auth.raspberrypi.org/oauth2/auth')
    end

    it 'should have correct token url' do
      expect(subject.options.client_options.token_url).to eq('https://auth.raspberrypi.org/oauth2/token')
    end
  end

  context '#email' do
    it 'should return email from raw_info if available' do
      allow(subject).to receive(:raw_info).and_return({ 'email' => 'you@example.com' })
      expect(subject.email).to eq('you@example.com')
    end

    it 'should return nil if there is no raw_info and email access is not allowed' do
      allow(subject).to receive(:raw_info).and_return({})
      expect(subject.email).to be_nil
    end
  end

  context '#fullname' do
    it 'should return fullname from raw_info if available' do
      allow(subject).to receive(:raw_info).and_return({ 'name' => 'Jane Doe' })
      expect(subject.fullname).to eq('Jane Doe')
    end

    it 'should return nil if there is no raw_info and fullname access is not allowed' do
      allow(subject).to receive(:raw_info).and_return({})
      expect(subject.fullname).to be_nil
    end
  end

  context '#nickname' do
    it 'should return nickname from raw_info if available' do
      allow(subject).to receive(:raw_info).and_return({ 'nickname' => 'Raspberry Jane' })
      expect(subject.nickname).to eq('Raspberry Jane')
    end

    it 'should return nil if there is no raw_info and nickname access is not allowed' do
      allow(subject).to receive(:raw_info).and_return({})
      expect(subject.nickname).to be_nil
    end
  end

  describe '#callback_url' do
    it 'is a combination of host and callback path' do
      allow(subject).to receive(:full_host).and_return('https://example.com')

      expect(subject.callback_url).to eq('https://example.com/auth/rpi/callback')
    end
  end
end
