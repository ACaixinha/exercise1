require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def set_session(user = users(:two))
    @user = user
    post sessions_url, params: { session: { password: 'some_password', username: @user.username } }
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
    assert data.first.keys.sort == %w[id username role].sort
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

  test 'should destroy user' do
    set_session
    old_user_id = @user.id
    assert_difference('User.count', -1) do
      delete user_url(@user), as: :json
    end
    assert_response :no_content
    assert_nil User.find_by id: old_user_id
  end

  test 'should update user deposit' do
    buyer = users(:one)
    set_session(buyer)
    current_deposit = @user.deposit

    valid_deposits = DepositForm::VALID_DEPOSITS
    valid_deposits.each do |deposit|
      post "/users/#{@user.id}/deposit", params: { deposit: }, as: :json
      assert_response :success
      @user.reload
      assert @user.deposit, current_deposit + deposit
    end
  end

  test 'should not update user deposit with invalid value' do
    set_session(users(:one))
    current_deposit = @user.deposit

    invalid_deposits = [1, 2, 8, 16, 42]
    invalid_deposits.each do |deposit|
      post "/users/#{@user.id}/deposit", params: { deposit: }, as: :json
      assert_response :unprocessable_entity
      assert response.parsed_body['deposit'] == ['is not included in the list']
      @user.reload
      assert @user.deposit, current_deposit
    end
  end

  test 'should not update user deposit if user is seller' do
    set_session
    current_deposit = @user.deposit

    post "/users/#{@user.id}/deposit", params: { deposit: 5 }, as: :json
    assert_response :forbidden
    assert @user.deposit, current_deposit
  end
end
