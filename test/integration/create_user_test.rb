require 'test_helper'
require 'test_helpers/user_helpers'
require "cgi"

class CreateUserTest < ActionDispatch::IntegrationTest
  include UserHelpers

  def setup
    @user_info = {
      username: "newuser",
      email: "newuser@email.com",
      password: "password",
      password_confirmation: "password"
    }
  end

  test "get signup page and create user" do
    get '/signup'
    assert_response :success
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: @user_info }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'newuser', response.body
  end

  test "try user creation and reject invalid username input" do
    @user_info[:username] = ""
    fail_user_creation(@user_info)
    assert_match "Username can't be blank", CGI.unescapeHTML(response.body)
  end

  test "try user creation and reject invalid email input" do
    @user_info[:email] = "newuseremail"
    fail_user_creation(@user_info)
    assert_match 'Email is invalid', response.body
  end

  test "try user creation and reject invalid password input" do
    @user_info[:password] = ""
    fail_user_creation(@user_info)
    assert_match "Password can't be blank", CGI.unescapeHTML(response.body)
  end

  test "try user creation and reject failed password confirmation" do
    @user_info[:password_confirmation] = "nomatch"
    fail_user_creation(@user_info)
    assert_match '"Password" and "Confirm password" must match', 
      CGI.unescapeHTML(response.body)
  end

  test "try user creation and reject using existing username" do
    test_user = create_test_user
    @user_info[:username] = test_user.username
    fail_user_creation(@user_info)
    assert_match 'Username has already been taken', response.body
  end

  test "try user creation and reject using existing email" do
    test_user = create_test_user
    @user_info[:email] = test_user.email
    fail_user_creation(@user_info)
    assert_match 'Email has already been taken', response.body
  end
end
