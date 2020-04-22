# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RpiAuthBypass do
  using described_class

  around do |example|
    # Alter logger to hide log messages.
    level = OmniAuth.config.logger.level = Logger::WARN

    example.run

    OmniAuth.config.disable_rpi_auth_bypass
    OmniAuth.config.logger.level = level
  end

  describe 'OmniAuth::Configuration#enable_rpi_auth_bypass' do
    subject { OmniAuth.config.enable_rpi_auth_bypass }

    it 'sets test_mode to true' do
      expect { subject }.to change { OmniAuth.config.test_mode }.from(false).to(true)
    end

    it 'adds the rpi mock' do
      expect { subject }.to change { OmniAuth.config.mock_auth[:rpi] }.from(nil)
    end
  end

  describe 'OmniAuth::Configuration#add_rpi_mock' do
    let(:args) { {} }

    before do
      OmniAuth.config.add_rpi_mock(args)
    end

    subject { OmniAuth.config.mock_auth[:rpi] }

    it 'has the default uid' do
      expect(subject.uid).to eq(RpiAuthBypass::DEFAULT_UID)
    end

    it 'has the default email' do
      expect(subject.info.email).to eq(RpiAuthBypass::DEFAULT_EMAIL)
    end

    it 'has the default name' do
      expect(subject.info.name).to eq(RpiAuthBypass::DEFAULT_NAME)
    end

    it 'has the default nickname' do
      expect(subject.info.nickname).to eq(RpiAuthBypass::DEFAULT_NICKNAME)
    end

    context 'with info specified' do
      let(:uid) { '1d27cca2-fef3-4f79-bc64-b76e93db84a2' }
      let(:name) { 'Robert Flemming' }
      let(:nickname) { 'Bob' }
      let(:email) { 'bob.flemming@example.com' }
      let(:info) { { name: name, email: email, nickname: nickname } }
      let(:args) { { uid: uid, info: info } }

      it 'has the uid' do
        expect(subject.uid).to eq(uid)
      end

      it 'has the email from info' do
        expect(subject.info.email).to eq(email)
      end

      it 'has the name from info' do
        expect(subject.info.name).to eq(name)
      end

      it 'has the nickname from info' do
        expect(subject.info.nickname).to eq(nickname)
      end
    end
  end
end
