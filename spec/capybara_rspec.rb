# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'

Capybara.server_host = '0.0.0.0'
Capybara.server_port = 3030

Capybara.register_driver :chrome_headless do |app|
  args = %w[--headless --disable-gpu --no-sandbox --disable-extensions --disable-dev-shm-usage --window-size=1024,768 --enable-features=NetworkService,NetworkServiceInProcess]
  options = Selenium::WebDriver::Chrome::Options.new(args: args)
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
Capybara.javascript_driver = :chrome_headless

# Setup rspec
RSpec.configure do |config|
  config.before(:each, type: :feature, js: true) do
    Capybara.current_driver = :chrome_headless
    Capybara.raise_server_errors = false
  end
end
