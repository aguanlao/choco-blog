require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = Post.new(
      title: "Test post", 
      description: "Test description.", 
      user: create_test_user
    )
  end

  test "post must be valid" do
    assert @post.valid?
  end

  test "post must belong to a valid user" do
    @post.user = User.new()
    assert_not @post.valid?
  end

  test "post title should be present" do
    @post.title = ""
    assert_not @post.valid?
  end

  test "post description should be present" do
    @post.description = ""
    assert_not @post.valid?
  end

  test "post title should be shorter than 129" do
    @post.title = "a" * 129
    assert_not @post.valid?
  end

  test "post title should be longer than 5" do
    @post.title = "a" * 5
    assert_not @post.valid?
  end

  test "post description should longer than 5" do
    @post.description = "a" * 5
    assert_not @post.valid?
  end
end