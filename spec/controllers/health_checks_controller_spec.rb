# frozen_string_literal: true

require 'rails_helper'
describe HealthChecksController, type: :controller do
  describe '#liveness' do
    it 'returns status ok when successfully called' do
      get :liveness
      expect(response).to have_http_status(:ok)
    end

    it 'returns status bad_request when DB connect failed' do
      error_msg = 'some error'
      allow(User).to receive(:count).and_raise(error_msg)
      get :liveness
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#readiness' do
    it 'returns status ok when successfully called' do
      get :readiness
      expect(response).to have_http_status(:ok)
    end
  end
end
