# frozen_string_literal: true

module TurboConcern
  extend ActiveSupport::Concern
  included do
    around_action :parse_turbo_frame, if: :turbo_frame_request?
    helper_method :turbo_request?, :turbo_frame_request_id
  end

  private

  def turbo_request?
    request.headers['turbo-request'].present?
  end

  # fix: automatically render content turbo frame caller tag
  def parse_turbo_frame
    begin
      yield
      content = response.body
    rescue => e # rubocop:disable Style/RescueStandardError
      print_turbo_error(e)
      content = ''
    end
    is_redirect = response.status == 302
    target = request.headers['Turbo-Frame'] || request.headers['turbo-target']
    render_turbo_content(turbo_target: target) { content } unless is_redirect
  end

  def render_turbo_content(turbo_target: nil, skip_flash: false, &block)
    content = block.call
    response.content_type = 'text/vnd.turbo-stream.html'
    content = "#{content}#{turbo_flash_messages}" unless skip_flash
    content = turbo_stream.update(turbo_target, content) if turbo_target
    response.body = content
  end

  # @param error (Exception)
  def print_turbo_error(error)
    Rails.logger.error ([error.message] + error.backtrace).join($RS)
    dev_msg = Rails.env.production? ? '' : " ==> #{error.message}"
    flash[:error] = "Internal error: #{dev_msg}"
  end

  # @return [String]
  def turbo_flash_messages
    flash_messages = render_to_string(partial: '/layouts/flash_messages')
    return '' if flash_messages.blank?

    content = turbo_stream.update('flash_messages', flash_messages)
    flash.clear # clear streamed flash messages
    content
  end
end
