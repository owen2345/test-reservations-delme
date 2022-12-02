# frozen_string_literal: true

require 'rails_helper'
describe Auth0Controller, type: :controller do
  let(:token) { 'some token' }
  before { allow(controller.request.env).to receive(:[]).and_call_original }

  describe '#callback' do
    let(:auth0_payload) { double(credentials: double(id_token: token)) }
    before do
      allow(controller.request.env).to receive(:[]).with('omniauth.auth').and_return(auth0_payload)
    end

    it 'initializes authenticated user' do
      expect(controller).to receive(:authenticate_request!).with(update_info: true)
      get :callback
    end

    it 'redirects to previous url' do
      prev_url = '/previous/url/'
      controller.session[:return_to] = prev_url
      allow(controller).to receive(:authenticate_request!)
      get :callback
      expect(response).to redirect_to(prev_url)
    end
  end

  describe '#login' do
    render_views

    it 'renders without layout' do
      get :login
      expect(response).to render_template(layout: false)
    end

    it 'includes login form' do
      get :login
      expect(response.body).to have_tag('form', with: { action: '/auth/auth0' })
    end
  end

  describe '#failure' do
    it 'redirects to login page' do
      get :failure
      expect(response).to redirect_to('/auth/login')
    end
  end

  describe 'logout' do
    it 'resets current session' do
      expect(controller).to receive(:reset_session)
      get :logout
    end

    it 'redirects to login page' do
      get :logout
      expect(response).to redirect_to('/auth/login')
    end
  end
end
