require 'test_helper'

class CreatePostWithCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_test_user
    sign_in_as(@user)
    @category = Category.create( name: "Fiji" )
  end

  test "get new post page and create post with category" do
    get '/posts/new'
    assert_response :success
    assert_difference 'Post.count', 1 do
      post posts_path, params: { 
        post: { 
          title: "Test post",
          description: "Test description",
          category_ids: [1]
        }
      }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Test post', response.body
    assert_match 'Fiji', response.body
  end
end
