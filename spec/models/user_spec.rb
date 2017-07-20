require 'rails_helper'

RSpec.describe User, type: :model do
  let(:jwt_payload) { [{ 'id' => user.id }] }
  let(:user_params) { { username: 'user', password: SecureRandom.hex(32) } }
  let(:user) { FactoryGirl.create :user }
  let(:token) { SecureRandom.hex(64) }
  subject { described_class }
  it { is_expected.to be }

  describe 'attributes' do
    it { expect(user.username).to be }
    it { expect(user.password_digest).to be }
  end

  describe '#to_jwt' do
    subject { user.to_jwt }

    it 'should encode with JWT' do
      expect(JWT).to receive(:encode).with({ id: user.id }, anything, 'HS256').and_call_original
      subject
    end
    it { is_expected.to be_a(String) }
  end

  describe '.from_token' do
    subject { User.from_token(token) }

    context 'with invalid token' do
      it { is_expected.to be_nil }
    end

    context 'with valid token' do
      before { allow(JWT).to receive(:decode).and_return(jwt_payload) }
      it  { is_expected.to eq(user) }
    end
  end
end
