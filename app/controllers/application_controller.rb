# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  include TurboConcern
  layout :resolve_layout

  private

  def resolve_layout
    turbo_frame_request? ? false : 'application'
  end
end
