# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  roles      :text             default("{}"), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :user do
    name { 'Some name' }
    sequence(:email) { |index| "some-#{index}@email.com" }
    roles { %w[admin editor] }
  end
end
