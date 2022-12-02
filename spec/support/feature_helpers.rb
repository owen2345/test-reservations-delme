# frozen_string_literal: true

module FeatureHelpers
  def then_it(_msg, &block)
    block.call
  end
end
RSpec.configure do |config|
  config.include FeatureHelpers
end
