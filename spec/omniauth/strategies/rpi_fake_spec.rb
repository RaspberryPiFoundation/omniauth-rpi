require 'spec_helper'

RSpec.describe OmniAuth::Strategies::RpiFake do
  subject(:strategy) { described_class.new({}) }

  let(:access_token) { instance_double('AccessToken', :options => {}) }
  let(:parsed_response) { instance_double('ParsedResponse') }
  let(:response) { instance_double('Response', :parsed => parsed_response) }

  let(:uid) { '1d27cca2-fef3-4f79-bc64-b76e93db84a2' }
  let(:name) { 'Robert Flemming' }
  let(:nickname) { 'Bob' }
  let(:email) { 'bob.flemming@example.com' }

  let(:development) do
    described_class.new(nil, uid: uid,
                        name: name,
                        email: email,
                        nickname: nickname)
  end

  context 'options' do
    it 'has the default email' do
      expect(strategy.options.email).to eq('web@raspberrypi.org')
    end

    it 'has the default name' do
      expect(strategy.options.name).to eq('Web Team')
    end

    it 'has the default nickname' do
      expect(strategy.options.nickname).to eq('Web')
    end

    it 'has the default uid' do
      expect(strategy.options.uid).to eq('b6301f34-b970-4d4f-8314-f877bad8b150')
    end
  end

  context '#email' do
    it 'returns default email' do
      expect(strategy.email).to eq('web@raspberrypi.org')
    end

    context 'with the email set in options' do
      it 'returns email from options' do
        expect(development.email).to eq(email)
      end
    end
  end

  context '#name' do
    it 'returns name from options' do
      pp strategy.options
      pp development.options
      expect(development.name).to eq(name)
    end
  end

  context '#nickname' do
    it 'returns email from options' do
      expect(development.email).to eq()
    end
  end
end
