# frozen_string_literal: true

class SlotsGenerator < ApplicationService
  attr_reader :date, :duration

  # @param date [Date]
  # @param duration [Integer] In minutes
  def initialize(date, duration)
    @date = date
    @duration = duration
  end

  def call
    calculate_available_slots
  end

  private

  def calculate_available_slots
    time_from = date.to_time.change(hour: 8, min: 0, sec: 0)
    time_to = date.to_time.change(hour: 18, min: 0, sec: 0)
    slots = day_slots(time_from, time_to)
    free_slots = exclude_busy_slots(slots)
    exclude_insufficient_slots(free_slots)
  end

  # @param slots [Array<slot>]
  def exclude_busy_slots(slots)
    busy_slots = ReservedSlot.in_date(date).pluck(:start_at, :end_at)
    busy_slots.each do |b_start_at, b_end_at|
      slots.reject! do |start_at, end_at|
        (start_at + 1.minute).between?(b_start_at, b_end_at) || (end_at - 1.minute).between?(b_start_at, b_end_at)
      end
    end
    slots
  end

  # @param slots [Array<slot>]
  def exclude_insufficient_slots(slots)
    slots.select.with_index do |slot, index|
      later_slot = last_sequence_slot(slots[index...])
      minutes = (later_slot[1] - slot[0]) / 1.minute
      minutes >= duration
    end
  end

  # last_sequence_item([[1,2], [2,3], [3,4], [6,7]])
  # @param slots [Array<slot>]
  def last_sequence_slot(slots)
    slots.find.with_index do |slot, index|
      next_slot = slots[index + 1]
      slot.last != next_slot&.first
    end
  end

  # @return [Array<Array<start, end>>]
  #   Array of time ranges. Sample: [[2022-10-01 08:00, 2022-10-01 08:15], [...]...]
  def day_slots(time_from, time_to)
    res = []
    while time_from <= time_to
      next_time = time_from.to_time + ReservedSlot::SLOT_INTERVAL.minutes
      res << [time_from, next_time] if next_time <= time_to
      time_from = next_time
    end
    res
  end
end
