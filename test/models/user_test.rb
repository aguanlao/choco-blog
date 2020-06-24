require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      username: "newuser",
      email: "newuser@email.com",
      password: "password"
    )
  end

  test "user must be valid" do
    assert @user.valid?
  end

  test "user username should be present" do
    @user.username = ""
    assert_not @user.valid?
  end

  test "user username should be unique" do
    test_user = create_test_user
    @user.username = test_user.username
    assert_not @user.valid?
  end

  test "user email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "user email should be unique" do
    test_user = create_test_user
    @user.email = test_user.email
    assert_not @user.valid?
  end

  test "user password should be present" do
    @user.password = nil
    assert_not @user.valid?
  end

  test "user username should be shorter than 26" do
    @user.username = "a" * 26
    assert_not @user.valid?
  end

  test "user username should be longer than 5" do
    @user.username = "a" * 5
    assert_not @user.valid?
  end

  test "user email should shorter than 129" do
    @user.email = "a" * 129
    assert_not @user.valid?
  end

  test "user password should be longer than 5" do
    @user.password = "a" * 5
    assert_not @user.valid?
  end
end