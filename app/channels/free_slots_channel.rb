# frozen_string_literal: true

class FreeSlotsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "changed_free_slots_#{params[:date]}"
  end
end
