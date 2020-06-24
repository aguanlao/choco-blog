require 'test_helper'
require 'test_helpers/user_helpers'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include UserHelpers

  setup do
    @user = create_test_user
    @user2 = User.create(
      username: "otheruser",
      email: "otheruser@email.com",
      password: "password"
    )
  end

  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should not get new if logged in" do
    sign_in_as(@user)
    get signup_url
    assert_redirected_to user_url(session[:user_id])
  end

  test "should create user" do
    assert_difference('User.count', 1) do
      post signup_url, params: { 
        user: {
          username: "newuser",
          email: "newuser@email.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end
    assert_redirected_to user_url(User.last)
    assert_equal "Signed up successfully. Welcome #{User.last.username}!",
      flash[:notice]
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    sign_in_as(@user)
    get edit_user_url(@user)
    assert_response :success
  end

  test "should not get edit if not same user" do
    sign_in_as(@user2)
    get edit_user_url(@user)
    assert_redirected_to user_url(@user)
    assert_equal 'You do not have permission to do that.', flash[:alert]
  end

  test "should update user" do
    sign_in_as(@user)
    assert_changes '@user.username' do
      @user = try_user_update(@user)
    end
    assert_redirected_to user_url(@user)
    assert_equal 'User was updated successfully.', flash[:notice]
  end

  test "should not update user if not logged in" do
    assert_no_changes '@user.username' do
      @user = try_user_update(@user)
    end
    assert_redirected_to login_url
    assert_equal 'You must be logged in to do that.', flash[:alert]
  end

  test "should not update user if not same user" do
    sign_in_as(@user2)
    assert_no_changes '@user.username' do
      @user = try_user_update(@user)
    end
    assert_redirected_to user_url(@user)
    assert_equal 'You do not have permission to do that.', flash[:alert]
  end

  test "should destroy user" do
    sign_in_as(@user)
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end
    assert_redirected_to posts_url
    assert_equal 'Successfully deleted account.', flash[:notice]
  end

  test "should not destroy user if not logged in" do
    assert_no_difference('User.count') do
      delete user_url(@user)
    end
    assert_redirected_to login_url
    assert_equal 'You must be logged in to do that.', flash[:alert]
  end

  test "should not destroy user if not same user" do
    sign_in_as(@user2)
    assert_no_difference('User.count') do
      delete user_url(@user)
    end
    assert_redirected_to user_url(@user)
    assert_equal 'You do not have permission to do that.', flash[:alert]
  end
end
