# frozen_string_literal: true

module Sync
  module UserConcern
    extend ActiveSupport::Concern
    included do
      include PubSubModelSync::SubscriberConcern
      include PubSubModelSync::PublisherConcern
      ps_after_action(:create) { ps_publish(:create, mapping: %i[name email]) }
      ps_subscribe(:create, %i[name email], id: :email)
    end
  end
end
