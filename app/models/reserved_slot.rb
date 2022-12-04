# frozen_string_literal: true

# == Schema Information
#
# Table name: reserved_slots
#
#  id         :integer          not null, primary key
#  start_at      :datetime
#  end_at        :datetime
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reserved_slots_on_user_id  (user_id)
#

class ReservedSlot < ApplicationRecord
  SLOT_INTERVAL = 15 # minutes

  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :check_availability, on: :create, if: %i[start_at end_at]
  validate :validate_range, on: :create, if: %i[start_at end_at]

  # callbacks
  after_commit :broadcast_free_slots, on: %i[create destroy]

  # scopes
  scope :in_date, ->(date) { where('start_at::DATE = ?', date) }
  scope :in_range, lambda { |start_at, end_at|
    where('start_at between :start_at and :end_at OR end_at between :start_at and :end_at', start_at:, end_at:)
  }

  private

  def validate_range
    errors.add(:start_at, :invalid, message: 'Start_at must be greater than End_at') if end_at < start_at
  end

  def check_availability
    taken = ReservedSlot.in_range(start_at + 1.minute, end_at).any?
    errors.add(:start_at, :busy, message: 'The slot range is already busy') if taken
  end

  def broadcast_free_slots
    ActionCable.server.broadcast("changed_free_slots_#{start_at.to_date}", { start_at: })
  end
end
