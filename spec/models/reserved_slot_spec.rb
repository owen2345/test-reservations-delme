# frozen_string_literal: true

require 'rails_helper'
describe ReservedSlot, type: :model do
  it 'creates a valid record' do
    expect { create(:reserved_slot) }.to change(described_class, :count)
  end

  describe 'when validating' do
    it 'fails when invalid range' do
      slot = build(:reserved_slot, start_at: Time.current, end_at: 1.hour.ago).tap(&:validate)
      expect(slot.errors.key?(:start_at)).to be_truthy
    end

    describe 'when validating existent reservations' do
      it 'fails when range was already taken with the same start_at' do
        _slot1 = create(:reserved_slot, start_at: Time.current).tap(&:validate)
        slot = build(:reserved_slot, start_at: Time.current).tap(&:validate)
        expect(slot.errors.key?(:start_at)).to be_truthy
      end

      it 'fails when range was already taken (started minutes ago)' do
        slot1 = create(:reserved_slot, start_at: Time.current).tap(&:validate)
        slot = build(:reserved_slot, start_at: slot1.start_at - 5.minutes).tap(&:validate)
        expect(slot.errors.key?(:start_at)).to be_truthy
      end

      it 'fails when range was already taken (starts before finishing)' do
        slot1 = create(:reserved_slot, start_at: Time.current).tap(&:validate)
        slot = build(:reserved_slot, start_at: slot1.start_at + 5.minutes).tap(&:validate)
        expect(slot.errors.key?(:start_at)).to be_truthy
      end
    end
  end

  describe '.in_range' do
    it 'filters for reservations that are in the given range' do
      create(:reserved_slot, start_at: 5.minutes.from_now)
      res = described_class.in_range(Time.current, 1.hour.from_now).any?
      expect(res).to be_truthy
    end
  end
end
