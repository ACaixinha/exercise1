# frozen_string_literal: true

class BuyForm
  include ActiveModel::Model

  attr_accessor(:user, :product, :ammount)

  validates :ammount, :product, presence: true
  validates :ammount, numericality: { greater_than: 0 }

  validate :user_can_pay
  validate :product_amount_is_available

  def user_can_pay
    can_pay = user.deposit >= (product.cost * ammount)
    errors.add(:ammount, 'Buyer is unable to pay') unless can_pay
  end

  def product_amount_is_available
    amount_is_available = product.amount_available >= ammount
    errors.add(:ammount, 'Product amount is not available') unless amount_is_available
  end

  def initialize(user, product, ammount)
    self.user = user
    self.product = product
    self.ammount = ammount
  end

  def save
    if valid?
      ActiveRecord::Base.transaction do
        user.deposit = (user.deposit - (product.cost * ammount))
        product.amount_available = product.amount_available - ammount
        user.save! && product.save!
      end
    else
      false
    end
  end
end
