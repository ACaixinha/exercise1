require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test 'validate amount_available presence' do
    product = Product.new
    refute product.valid?
    assert_not_nil product.errors[:amount_available]
  end

  test 'validate cost presence' do
    product = Product.new
    refute product.valid?
    assert_not_nil product.errors[:cost]
  end

  test 'validate product_name presence' do
    product = Product.new
    refute product.valid?
    assert_not_nil product.errors[:product_name]
  end

  test 'validate seller presence' do
    product = Product.new
    refute product.valid?
    assert_not_nil product.errors[:seller]
  end

  test 'validate cost is invalid when not multiple of 5' do
    [6, 8, 18, 23, 30, 42, 101].each do |cost|
      product = Product.new(cost: cost)
      refute product.valid?
      assert_not_nil product.errors[:cost]
    end
  end

  test 'validate cost is valid when a multiple of 5' do
    [5, 10, 15, 20, 30, 45, 50].each do |cost|
      product = Product.new(cost: cost)
      refute product.valid?
      assert [], product.errors[:cost]
    end
  end
end
