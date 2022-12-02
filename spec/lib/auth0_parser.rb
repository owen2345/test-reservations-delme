# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('lib/auth0_parser')
describe Auth0Parser do
  let(:token) { 'some token' }
  let(:user) { build(:user) }
  let(:token_details) do
    {
      'https://buddy.buddyandselly.com/email' => user.email,
      'nickname' => user.name,
      'https://buddy.buddyandselly.com/roles' => user.roles,
      'exp' => 5.minutes.from_now.to_i
    }
  end
  before { mock_token_details(token_details) }

  it 'retrieves email value from expected attribute' do
    allow(token_details).to receive(:[]).and_call_original
    expect(token_details).to receive(:[]).with('https://buddy.buddyandselly.com/email')
    described_class.call(token)
  end

  it 'returns parsed token data' do
    res = described_class.call(token)
    expect(res).to match({ email: user.email, name: user.name, roles: user.roles })
  end

  describe 'when verifying expiration' do
    it 'raises ExpiredToken error when expired' do
      mock_token_details(token_details.merge('exp' => 1.minute.ago))
      expect { described_class.call(token) }.to raise_error(Auth0Parser::ExpiredToken, 'Session expired')
    end

    it 'does not raise error when not expired yet' do
      mock_token_details(token_details.merge('exp' => 5.minutes.from_now))
      expect { described_class.call(token) }.not_to raise_error
    end
  end

  it 'supports short way to call parser' do
    mock_token_details(token_details)
    res = described_class.call(token)
    expect(res).not_to be_nil
  end

  private

  def mock_token_details(details)
    allow(JWT).to receive(:decode).and_return([details])
  end
end
