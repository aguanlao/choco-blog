require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = Category.create(name: "Fiji")
    @admin = User.create(
      username: "theadmin", 
      email: "admin@email.com", 
      password: "password", 
      is_admin: true
    )
  end

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get new" do
    sign_in_as(@admin)
    get new_category_url
    assert_response :success
  end

  test "should not get new if not admin" do
    get new_category_url
    assert_redirected_to posts_url
    assert_equal 'You must be an administrator to do that.', flash[:alert]    
  end

  test "should create category as admin" do
    sign_in_as(@admin)
    assert_difference('Category.count', 1) do
      post categories_url, params: { category: { name: "Vietnam" } }
    end
    assert_redirected_to category_url(Category.last)
    assert_equal 'Category created successfully.', flash[:notice]
  end

  test "should not create category if not admin" do
    assert_no_difference('Category.count') do
      post categories_url, params: { category: { name: "Vietnam" } }
    end
    assert_redirected_to posts_url
    assert_equal 'You must be an administrator to do that.', flash[:alert]
  end

  test "should show category" do
    get category_url(@category)
    assert_response :success
  end

  test "should get edit" do
    sign_in_as(@admin)
    get edit_category_url(@category)
    assert_response :success
    assert_select '#category_name' do
      assert_select '[value=?]', @category.name
    end
  end

  test "should not get edit if not admin" do
    get edit_category_url(@category)
    assert_response :redirect
    assert_match 'You must be an administrator to do that.', flash[:alert]
  end

  test "should update category" do
    sign_in_as(@admin)
    assert_changes '@category.name' do
      @category = try_category_update(@category)
    end    
    assert_redirected_to category_url(@category)
    assert_match 'Category updated successfully.', flash[:notice]
  end

  test "should not update category if not admin" do
    assert_no_changes '@category.name' do
      @category = try_category_update(@category)
    end
    assert_response :redirect
    assert_match 'You must be an administrator to do that.', flash[:alert]
  end

  test "should destroy category" do
    sign_in_as(@admin)
    assert_no_difference('Post.count') do
      assert_difference('Category.count', -1) do
        delete category_url(@category)
      end
    end
    assert_redirected_to categories_url
    assert_match "Category '#{@category.name}' deleted.", flash[:notice]
  end

  test "should not destroy category if not admin" do
    assert_no_difference('Category.count') do
      delete category_url(@category)
    end
    assert_response :redirect
    assert_match 'You must be an administrator to do that.', flash[:alert]
  end
  
  test "should destroy category and associations to posts" do
    sign_in_as(@admin)
    Post.create(
      title: "Test title",
      description: "Test description",
      category_ids: [1],
      user: @admin
    )
    user = create_test_user
    Post.create(
      title: "Another test",
      description: "Another description",
      category_ids: [1],
      user: user
    )
    assert_difference('Category.count', -1) do
      assert_difference('PostCategory.count', -2) do
        delete category_url(@category)
      end
    end
    assert_empty Post.first.category_ids
    assert_empty Post.last.category_ids
    assert_redirected_to categories_url
    assert_match "Category '#{@category.name}' deleted.", flash[:notice]
  end
end
