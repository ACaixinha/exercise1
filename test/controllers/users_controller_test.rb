require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def set_session
    @user = users(:two)
    post sessions_url, params: { session: { password: 'some_password', username: 'some_user' } }
  end

  test 'should get index' do
    users(:one)
    set_session
    get users_url, as: :json
    assert_response :success
  end

  test 'should get index and return only username, role and id' do
    users(:one)
    set_session
    get users_url, as: :json
    assert_response :success
    data = response.parsed_body
    assert data.first.keys == %w[username role id]
  end

  test 'should get index and return only sellers and current user' do
    users(:one)
    set_session
    get users_url, as: :json
    assert_response :success
    data = response.parsed_body
    assert data.map { |d| d['role'] }.uniq.size == 1
    assert data.map { |d| d['role'] }.uniq.first == 'seller'
    assert data.map { |d| d['id'] }.uniq.include?(@user.id)
  end

  test 'should create user/user registration' do
    post users_url, params: { user: {
      password: 'new_password',
      username: 'new_user',
      role: User::BUYER_ROLE
    } }
    assert_response :success

    user = User.find_by(username: 'new_user')
    assert user.present?
    assert user.role = User::BUYER_ROLE
  end

  test 'should show user' do
    set_session
    get user_url(@user), as: :json
    assert_response :success
  end

  test 'should update user deposit' do
    set_session
    patch user_url(@user), params: { user: { deposit: 10 } }, as: :json
    assert_response :success
  end

  test 'should destroy user' do
    set_session
    old_user_id = @user.id
    assert_difference('User.count', -1) do
      delete user_url(@user), as: :json
    end
    assert_response :no_content
    assert_nil User.find_by id: old_user_id
  end
end
