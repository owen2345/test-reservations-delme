# frozen_string_literal: true

class CreateReservedSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :reserved_slots do |t|
      t.datetime :start_at, unique: true, null: false
      t.datetime :end_at, null: false
      t.integer :user_id, index: true, null: true

      t.timestamps
    end
  end
end
