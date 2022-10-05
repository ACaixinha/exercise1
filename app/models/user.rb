require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  BUYER_ROLE='buyer' 
  SELLER_ROLE='seller' 

  validates :username, presence: true
  validates :password, presence: true
  validates :role, presence: true

  has_many :products, dependent: :destroy, foreign_key: :seller_id

  def password
    @password ||= encrypted_password.present? ? Password.new(encrypted_password) : nil
  end

  def password=(new_password)
    if new_password.present?
      @password = Password.create(new_password)
      self.encrypted_password = @password
    else
      self.encrypted_password = nil
    end
  end

  def authenticate(login_password)
    login_password.present? && password == login_password
  end

end
