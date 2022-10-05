class Product < ApplicationRecord
  belongs_to :seller, class_name: 'User'

  validates :amount_available, :cost, :product_name, presence: true
  validate :cost_is_a_multiple_of_five

  private
  def cost_is_a_multiple_of_five
    errors.add(:cost, 'Must be a multiple of 5') if cost.nil? || cost.remainder(5) != 0
  end
end
