# frozen_string_literal: true
class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :username, length: { minimum: 3, maximum: 50 }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
end
