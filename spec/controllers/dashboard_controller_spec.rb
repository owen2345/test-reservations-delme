# frozen_string_literal: true

require 'rails_helper'
describe DashboardController, type: :controller do
  it 'renders the dashboard page' do
    mock_session(build(:user))
    get :index
    expect(response).to have_http_status(:ok)
  end
end
