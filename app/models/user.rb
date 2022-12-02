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

class User < ApplicationRecord
  include Sync::UserConcern
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # @param token_data (Hash<name: String, email: String, roles: Array<String>>)
  def self.from_token_data(token_data, update_info: false)
    user = User.where(email: token_data[:email]).first_or_create!(token_data)
    user.update!(token_data) if update_info
    user
  end
end
