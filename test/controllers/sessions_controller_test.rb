require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should create session' do
    post sessions_url, params: { session: { password: 'some_password', username: 'some_user' } }
    assert_response :ok
    assert session[:username] == 'some_user'
  end

  test 'should fail on missing password' do
    post sessions_url, params: { session: { password: '', username: 'some_user' } }
    assert_response 422
  end

  test 'should fail on missing username' do
    post sessions_url, params: { session: { password: 'some_password', username: '' } }
    assert session[:username].blank?
    assert_response 422
  end

  test 'should fail to create session on wrong password' do
    post sessions_url, params: { session: { password: 'wrong_password', username: 'some_user' } }
    assert session[:username].blank?
    assert_response 401
  end

  test 'should fail to create session on wrong user' do
    post sessions_url, params: { session: { password: 'wrong_password', username: 'wrong_user' } }
    assert session[:username].blank?
    assert_response 401
  end

  test 'should destroy the session on logout' do
    post sessions_url, params: { session: { password: 'some_password', username: 'some_user' } }
    assert session[:username] == 'some_user'

    delete session_url(session[:user_id])
    assert session[:username].blank?
  end

end
