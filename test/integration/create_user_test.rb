require 'test_helper'
require 'test_helpers/user_helpers'

class CreateUserTest < ActionDispatch::IntegrationTest
  include UserHelpers

  test "get signup page and create user" do
    get '/signup'
    assert_response :success
    assert_difference 'User.count', 1 do
      post signup_path, params: { 
        user: { 
          username: "newuser", 
          email: "newuser@email.com",
          password: "password"
        } 
      }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'newuser', response.body
  end

  test "try user creation and reject invalid user input" do
    user_info = { 
      username: "newuser", 
      email: "newuseremail", 
      password: "password" 
    }
    fail_user_creation(user_info)
    assert_match 'Email is invalid', response.body
  end

  test "try user creation and reject using existing username" do
    test_user = create_test_user
    user_info = { 
      username: test_user.username, 
      email: "user@email.com", 
      password: "password" 
    }
    fail_user_creation(user_info)
    assert_match 'Username has already been taken', response.body
  end

  test "try user creation and reject using existing email" do
    test_user = create_test_user
    user_info = {
      username: "otheruser",
      email: test_user.email,
      password: "password"
    }
    fail_user_creation(user_info)
    assert_match 'Email has already been taken', response.body
  end
end
