# frozen_string_literal: true

module SessionHelpers
  def mock_session(user, controller: nil)
    expected = controller ? allow(controller) : allow_any_instance_of(ApplicationController)
    expected.to receive(:authenticate_request!)
    expected.to receive(:current_user).and_return(user)
  end
end

RSpec.configure do |config|
  config.include SessionHelpers
end
