# frozen_string_literal: true

require 'rails_helper'
describe SlotsGenerator, type: :service do
  let(:date) { Time.current.to_date }
  let(:slot_interval) { 15 }
  let(:duration) { 30 }
  let(:total_day_slots) { (1.hour / slot_interval.minutes) * 24 }
  let(:inst) { described_class.new(date, duration) }
  before do
    stub_const('ReservedSlot::SLOT_INTERVAL', slot_interval)
  end

  describe 'when calculating available slots' do
    it 'returns the list of slots' do
      expect(inst.call.first).to match_array([be_a(Time), be_a(Time)])
    end
  end

  describe 'when excluding busy slots' do
    it 'excludes the busy slots' do
      start_at = Time.zone.parse('10:00')
      create(:reserved_slot, start_at:, end_at: start_at + slot_interval.minutes)
      start_dates = inst.call.map(&:first)
      expect(start_dates).not_to include(start_at)
    end
  end

  describe 'when excluding insufficient slots that supports the given period' do
    it 'excludes insufficient slots' do
      create(:reserved_slot, start_at: Time.zone.parse('10:00'), end_at: Time.zone.parse('10:30'))
      create(:reserved_slot, start_at: Time.zone.parse('10:45'), end_at: Time.zone.parse('11:00'))
      start_dates = inst.call.map(&:first)
      expect(start_dates).not_to include(Time.zone.parse('10:30'))
    end

    it 'keeps sufficient slots' do
      create(:reserved_slot, start_at: Time.zone.parse('10:00'), end_at: Time.zone.parse('10:30'))
      create(:reserved_slot, start_at: Time.zone.parse('11:00'), end_at: Time.zone.parse('11:30'))
      start_dates = inst.call.map(&:first)
      expect(start_dates).to include(Time.zone.parse('10:30'))
    end
  end

  describe 'when generating slots for the day' do
    it 'generates slots for the whole day' do
      expect(inst.call.count).to eq(total_day_slots)
    end

    it 'starts at 00:00' do
      first_slot = inst.call.first
      expect(first_slot[0]).to eq(Time.zone.parse('00:00'))
    end

    it 'ends at 23:45' do
      last_slot = inst.call.last
      expect(last_slot[0]).to eq(Time.zone.parse('23:45'))
    end
  end
end
