# frozen_string_literal: true
class V1::UserForm
  include ActiveModel::Model
  include ActiveModel::Validations
  include Virtus.model

  attribute :email, String
  attribute :username, String
  attribute :password, String
  attribute :password_confirmation, String

  validates :email, presence: true
  validate :email_unique
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, length: { minimum: 3, maximum: 50 }
  validate :username_unique
  validates :password, length: { minimum: 8 }
  validate :password_confirmed

  def save
    if valid?
      User.create!(email: email, username: username, password: password)
      true
    else
      false
    end
  end

  private

  def password_confirmed
    if password != password_confirmation
      errors.add(:password, 'and password confirmation does not match')
    end
  end

  def email_unique
    if User.find_by_email(email)
      errors.add(:email, 'must be uniq')
    end
  end

  def username_unique
    if User.find_by_email(username)
      errors.add(:username, 'must be uniq')
    end
  end
end
