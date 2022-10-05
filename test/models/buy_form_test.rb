require 'test_helper'

class BuyFormTest < ActiveSupport::TestCase
  test 'validates user can buy product' do
    user = users('one')
    product = products('one')
    form = BuyForm.new(user, product, 2)
    assert form.valid?
  end

  test 'fails id user can not buy product' do
    user = users('one')
    product = products('one')
    form = BuyForm.new(user, product, 4)
    form.valid?
    assert form.errors[:ammount].include?('Buyer is unable to pay')
  end

  test 'validates there is enough available product' do
    user = users('one')
    product = products('one')
    form = BuyForm.new(user, product, 2)
    form.valid?
    refute form.errors[:ammount].include?('Product amount is not available')
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
end
