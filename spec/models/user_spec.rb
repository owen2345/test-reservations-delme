# frozen_string_literal: true

require 'rails_helper'
RSpec.describe User, type: :model do
  it 'creates a valid user' do
    expect { create(:user) }.to change(User, :count)
  end

  describe '#from_token_data' do
    let(:token_data) { build(:user).as_json(only: %i[name email roles]).symbolize_keys }

    it 'returns the existent user if already created' do
      user = create(:user, email: token_data[:email])
      res = described_class.from_token_data(token_data)
      expect(res).to eq(user)
    end

    it 'returns a new user if not existed yet' do
      expect { described_class.from_token_data(token_data) }.to change(User, :count)
    end

    it 'updates the user info if defined' do
      user = create(:user, email: token_data[:email], name: 'old name')
      res = described_class.from_token_data(token_data, update_info: true)
      expect(user.reload.name).to eq(res.name)
    end
  end
end
