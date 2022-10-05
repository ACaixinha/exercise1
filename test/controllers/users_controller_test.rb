require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
  end

  test "should get index" do
    #todo require authentication
    #todo user should see only own account
    get users_url, as: :json
    assert_response :success
  end

  test 'should create user/user registration' do
    post users_url, params: { user: {
      password: 'new_password',
      username: 'new_user',
      role: User::BUYER_ROLE
    } 
  }
    assert_response :success

    user = User.find_by(username: 'new_user')
    assert user.present?
    assert user.role = User::BUYER_ROLE
  end


  test "should show user" do
    #todo require authentication
    #todo user should see only own account
    get user_url(@user), as: :json
    assert_response :success
  end

  test "should update user deposit" do
    patch user_url(@user), params: { user: { deposit: 10} }, as: :json
    assert_response :success
  end

  test "should destroy user" do
    #todo require authentication
    #todo user should delete only own account
    assert_difference("User.count", -1) do
      delete user_url(@user), as: :json
    end

    assert_response :no_content
  end
end
