# frozen_string_literal: true

module PubsubHelpers
  # @param action (Symbol)
  # @param klass (String, default described_class name)
  # @param data (Hash, optional) notification data
  # @param info (Hash, optional) notification info
  # @param headers (Hash, optional) notification headers
  def expect_publish_notification(action, klass: described_class.to_s, data: {}, info: {}, headers: {})
    publisher = PubSubModelSync::MessagePublisher
    exp_data = have_attributes(data: hash_including(data),
                               info: hash_including(info.merge(klass:, action:)),
                               headers: hash_including(headers))
    allow(publisher).to receive(:publish!).and_call_original
    expect(publisher).to receive(:publish!).with(exp_data)
  end
end

RSpec.configure do |config|
  config.include PubsubHelpers
end
