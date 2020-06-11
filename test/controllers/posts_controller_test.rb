require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_test_user
    @post = Post.create(
      title: "Testing controller", 
      description: "Description",
      user: @user
    )
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get new" do
    sign_in_as(@user)
    get new_post_url
    assert_response :success
  end

  test "should not get new if not logged in" do
    get new_post_url
    assert_redirected_to login_url
  end

  test "should create post" do
    sign_in_as(@user)
    assert_difference('Post.count', 1) do
      post posts_url, params: { 
        post: { 
          title: "Create title", 
          description: "Description", 
          user: @user 
        } 
      }
    end
    assert_redirected_to post_url(Post.last)
  end

  test "should not create post if not logged in" do
    assert_no_difference('Post.count') do
      post posts_url, params: { 
        post: { 
          title: "Create title", 
          description: "Description", 
          user: @user 
        } 
      }
    end
    assert_redirected_to login_url
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    sign_in_as(@user)
    get edit_post_url(@post)
    assert_response :success
  end

  test "should not get edit if not logged in" do    
    get edit_post_url(@post)
    assert_redirected_to login_url
  end

  test "should not get edit if not post author" do
    @other_user = User.create(
      username: "otheruser", 
      email: "other@email.com", 
      password: "password", 
      is_admin: false
    )
    sign_in_as(@other_user)    
    get edit_post_url(@post)
    assert_redirected_to post_url(@post)
  end

  test "should update post" do
    sign_in_as(@user)
    assert_changes '@post.title + " " + @post.description' do
      @post = try_post_update
    end
    assert_redirected_to post_url(@post)
  end

  test "should not update post if not logged in" do
    assert_no_changes '@post.title + " " + @post.description' do
      @post = try_post_update
    end
    assert_redirected_to login_url
  end

  test "should not update post if not post author" do
    @other_user = User.create(
      username: "otheruser", 
      email: "other@email.com", 
      password: "password", 
      is_admin: false
    )
    sign_in_as(@other_user)
    assert_no_changes '@post.title + " " + @post.description' do
      @post = try_post_update
    end
    assert_redirected_to post_url(@post)    
  end

  test "should destroy post" do
    sign_in_as(@user)
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end

  test "should not destroy post if not logged in" do
    assert_no_difference('Post.count') do
      delete post_url(@post)
    end

    assert_redirected_to login_url
  end

  private

  def try_post_update
    post_id = @post.id
    patch post_url(@post), params: { 
      post: { title: "Updated title", description: "Edited description" } 
    }
    Post.find(post_id)      
  end
end
