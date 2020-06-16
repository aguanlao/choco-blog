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

  # test "should get edit" do
  #   get edit_category_url(@category)
  #   assert_response :success
  # end

  # test "should update category" do
  #   patch category_url(@category), params: { category: {  } }
  #   assert_redirected_to category_url(@category)
  # end

  # test "should destroy category" do
  #   assert_difference('Category.count', -1) do
  #     delete category_url(@category)
  #   end

  #   assert_redirected_to categories_url
  # end
end
