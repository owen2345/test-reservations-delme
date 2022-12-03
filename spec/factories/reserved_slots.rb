# frozen_string_literal: true

FactoryBot.define do
  factory :reserved_slot do
    start_at { Time.current }
    end_at { start_at + ReservedSlot::SLOT_INTERVAL.minutes }
    sequence(:user_id) { |i| i }
  end
end
