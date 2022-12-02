# frozen_string_literal: true

class Auth0Controller < ApplicationController
  skip_before_action :authenticate_request!

  def callback
    # OmniAuth stores the informatin returned from Auth0 and the IdP in request.env['omniauth.auth'].
    # In this code, you will pull the raw_info supplied from the id_token and assign it to the session.
    # Refer to https://github.com/auth0/omniauth-auth0#authentication-hash for complete information
    # on 'omniauth.auth' contents.
    auth_info = request.env['omniauth.auth']
    session[:token] = auth_info.credentials.id_token
    authenticate_request!(update_info: true)
    redirect_to(session.delete(:return_to) || root_url)
  end

  def login
    render layout: false
  end

  def failure
    flash[:error] = request.params['message']
    redirect_to url_for(action: :login)
  end

  def logout
    reset_session
    redirect_to url_for(action: :login)
  end
end
