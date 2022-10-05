require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  test 'validate username presence' do
    session_form = Session.new(password: 'some_password')
    refute session_form.valid?
    assert_not_nil session_form.errors[:username]
  end

  test 'validate password presence' do
    session_form = Session.new()
    refute session_form.valid?
    assert_not_nil session_form.errors[:password].include?("can't be blank")
  end

  test 'validate empty password presence' do
    session_form = Session.new(password: '    ')
    refute session_form.valid?
    assert_not_nil session_form.errors[:password].include?("can't be blank")
  end
end
