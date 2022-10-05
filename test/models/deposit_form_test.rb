require 'test_helper'

class DepositFormTest < ActiveSupport::TestCase
  test 'should validate deposit value is in valid_deposits whitelist' do
    @user = users(:one)
    current_deposit = @user.deposit

    DepositForm::VALID_DEPOSITS.each do |deposit|
      form = DepositForm.new(@user, deposit)
      assert form.valid?
    end

    [1, 2, 3, 12, 23, 51, 62, 889].each do |deposit|
      form = DepositForm.new(@user, deposit)
      refute form.valid?
    end
  end
end
