# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OmniAuth::Strategies::RpiFake do
  subject { described_class.new({}, options) }

  let(:options) { {} }

  context 'client options'
  it 'has the default email' do
    expect(subject.email).to eq(described_class::DEFAULT_EMAIL)
  end

  it 'has the default name' do
    expect(subject.options.name).to eq(described_class::DEFAULT_NAME)
  end

  it 'has the default nickname' do
    expect(subject.options.nickname).to eq(described_class::DEFAULT_NICKNAME)
  end

  it 'has the default uid' do
    expect(subject.options.uid).to eq(described_class::DEFAULT_UID)
  end

  context 'with options specified' do
    let(:uid) { '1d27cca2-fef3-4f79-bc64-b76e93db84a2' }
    let(:name) { 'Robert Flemming' }
    let(:nickname) { 'Bob' }
    let(:email) { 'bob.flemming@example.com' }

    let(:options) { { uid: uid, name: name, email: email, nickname: nickname } }

    it 'has the email from options' do
      expect(subject.email).to eq(email)
    end

    it 'has the name from options' do
      expect(subject.name).to eq(name)
    end

    it 'has the nickname from options' do
      expect(subject.nickname).to eq(nickname)
    end

    it 'has the uid from options' do
      expect(subject.uid).to eq(uid)
    end
  end
end
