# frozen_string_literal: true

class Time
  def in_current_zone
    asctime.in_time_zone(Time.zone.name)
  end
end
