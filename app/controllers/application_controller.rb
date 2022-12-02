# frozen_string_literal: true

require Rails.root.join('lib/auth0_parser')
class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :authenticate_request!
  include ApplicationHelper
  helper_method :current_user
  layout :resolve_layout
  attr_reader :current_user

  private

  def set_locale
    session[:locale] = params[:locale] if params[:locale].present?
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def authenticate_request!(update_info: false)
    return redirect_to_login unless session[:token]

    token_data = Auth0Parser.call(session[:token])
    @current_user = User.from_token_data(token_data, update_info:)
  rescue => e # rubocop:disable Style/RescueStandardError
    redirect_to_login(e.message)
  end

  def redirect_to_login(error_msg = nil)
    return head(:forbidden) if request.xhr?

    session[:return_to] = request.fullpath
    flash[:error] = error_msg if error_msg
    redirect_to(auth_login_path)
  end

  def resolve_layout
    turbo_frame_request? ? false : 'application'
  end

  def render_turbo_content(flash_messages: true, &block)
    return unless turbo_frame_request?

    content = ''
    content += render_flash_messages if flash_messages
    content += block ? block.call : render
    response.body = content
    response.content_type = 'text/vnd.turbo-stream.html'
  end

  # @return [String]
  def render_flash_messages
    content = turbo_stream.append('toasts', render_to_string(partial: '/layouts/flash_messages'))
    flash.clear # clear streamed flash messages
    content
  end
end
