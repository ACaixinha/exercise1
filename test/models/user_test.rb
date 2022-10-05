require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'the password is stored encrypted' do
    user = User.find_by(username: 'some_user')
    assert user.encrypted_password != 'some_password'
    assert user.password == 'some_password'
  end

  test 'authentication works with the correct password' do
    user = User.find_by(username: 'some_user')
    assert user.authenticate('some_password')
  end

  test 'validate username presence' do
    user = User.new(password: 'some_password')
    refute user.valid?
    assert_not_nil user.errors[:username]
  end

  test 'validate password presence' do
    user = User.new
    refute user.valid?
    assert_not_nil user.errors[:password]
  end
end
