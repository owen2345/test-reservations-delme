# frozen_string_literal: true

class HealthChecksController < ActionController::Base # rubocop:disable Rails/ApplicationController
  def liveness
    User.count
    head :ok
  rescue => e # rubocop:disable Style/RescueStandardError
    Rails.logger.info "***** Health checker: #{e.message}"
    head :bad_request
  end

  def readiness
    head :ok
  end
end
