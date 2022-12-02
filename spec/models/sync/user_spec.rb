# frozen_string_literal: true

require 'rails_helper'
RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'when syncing data from other apps' do
    it 'creates user when received :create notification' do
      data = user.as_json(only: %i[name email])
      payload = PubSubModelSync::Payload.new(data, { klass: 'User', action: :create })
      expect { payload.process! }.to change(described_class, :count)
    end
  end

  describe 'when publishing sync', truncate: true, sync: true do
    it 'publishes user notification when created' do
      expect_publish_notification(:create, klass: 'User', data: { email: user.email })
      user.save!
    end
  end
end
