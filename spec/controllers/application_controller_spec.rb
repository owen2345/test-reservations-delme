# frozen_string_literal: true

require 'rails_helper'
describe ApplicationController, type: :controller do
  controller do
    def index
      head :ok
    end
  end

  describe 'when switching locale' do
    it 'set the new locale if locale is present in the request' do
      locale = 'pl'
      allow(session).to receive(:[]=)
      expect(session).to receive(:[]=).with(:locale, locale)
      get :index, params: { locale: }
    end
  end

  describe 'when verifying authentication' do
    before { allow(controller.session).to receive(:[]).and_call_original }

    it 'redirects to login url if no authentication exist' do
      allow(controller.session).to receive(:[]).with(:token).and_return(nil)
      get :index
      expect(response.body).to redirect_to('/auth/login')
    end

    it 'redirects to login url if invalid authentication' do
      allow(controller.session).to receive(:[]).with(:token).and_return('invalid token')
      get :index
      expect(response.body).to redirect_to('/auth/login')
    end

    it 'saves request path to return to once logged in' do
      expect(controller.session).to receive(:[]=).with(:return_to, anything)
      get :index
    end

    it 'returns :forbidden if called via ajax' do
      request.headers['X-Requested-With'] = 'XMLHttpRequest'
      get :index
      expect(response).to have_http_status(:forbidden)
    end

    it 'retrieves the authenticated user' do
      auth_data = {}
      allow(controller.session).to receive(:[]).with(:token).and_return('valid-token')
      allow(Auth0Parser).to receive(:call).and_return(auth_data)
      expect(User).to receive(:from_token_data).with(auth_data, anything)
      get :index
    end
  end

  describe 'when request is done via turbo request' do
    render_views
    controller do
      def index
        flash[:notice] = 'flash msg'
        render_turbo_content { render inline: 'some content' }
      end
    end
    before do
      request.headers['Turbo-Frame'] = true
      mock_session(build(:user), controller:)
    end

    it 'renders without layout if called via turbo request' do
      get :index
      expect(response).to render_template(layout: false)
    end

    it 'renders flash messages via turbo' do
      get :index
      expect(response.body).to have_tag('div', with: { 'data-controller' => 'toast' }, content: 'flash msg')
    end

    it 'renders the expected content' do
      get :index
      expect(response.body).to include('some content')
    end

    it 'resets current flash messages' do
      flash = controller.flash
      allow(controller).to receive(:flash).and_return(flash)
      expect(flash).to receive(:clear)
      get :index
    end
  end
end
