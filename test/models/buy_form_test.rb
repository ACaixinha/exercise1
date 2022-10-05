require 'test_helper'

class BuyFormTest < ActiveSupport::TestCase

  test 'validates ammount not null' do
    user = users('one')
    product = products('one')
    form = BuyForm.new(user, product, nil)
    refute form.valid?
    assert form.errors[:ammount], ["must be greater than 0"]
  end

  test 'validates ammount greater than 0' do
    user = users('one')
    product = products('one')
    form = BuyForm.new(user, product, 0)
    refute form.valid?
    assert form.errors[:ammount], ["must be greater than 0"]
  end

  test 'validates user can buy product' do
    user = users('one')
    product = products('one')
    form = BuyForm.new(user, product, 2)
    assert form.valid?
  end

  test 'fails if user can not pay product' do
    user = users('one')
    product = products('one')
    form = BuyForm.new(user, product, 4)
    form.valid?
    assert form.errors[:ammount].include?('Buyer is unable to pay')
  end

  test 'fails if there is enough available product' do
    user = users('one')
    product = products('one')
    form = BuyForm.new(user, product, product.amount_available + 1)
    form.valid?
    assert form.errors[:ammount].include?('Product amount is not available')
  end

  test '#save' do
    user = users('one')
    product = products('one')
    ammount = 2
    form = BuyForm.new(user, product, ammount)
    old_deposit = user.deposit
    old_amount_available = product.amount_available
    assert form.save
    user.reload
    product.reload
    assert user.deposit == (old_deposit - (product.cost * ammount))
  end

  test '#save fails on concurrent deposit withdrawl' do
    user = users('one')
    product = products('one')
    ammount = 2
    form = BuyForm.new(user, product, ammount)
    old_deposit = user.deposit
    old_amount_available = product.amount_available
    user.update_column :deposit, 0
    refute form.save
    assert form.errors[:ammount].include?('Buyer is unable to pay')
  end

  test '#change' do
    [
      [125, 2, [100, 10, 5]],
      [225, 2, [100, 100, 10, 5]],
      [10, 2, []],
      [200, 5, [100, 50, 20, 5]]
    ].each do |deposit, ammount, result|
      user = users('one')
      user.update(deposit:)
      product = products('one')
      product.update(amount_available:5)
      ammount = ammount
      form = BuyForm.new(user, product, ammount)
      old_deposit = user.deposit
      old_amount_available = product.amount_available
      assert form.save
      assert form.change, result
    end
  end
end
