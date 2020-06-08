require 'test_helper'

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create(
      username: "theadmin", 
      email: "admin@email.com", 
      password: "password", 
      is_admin: true
    )
    sign_in_as(@admin, "password")
  end

  test "get new category page and create category" do
    get '/categories/new'
    assert_response :success
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: "Ecuador" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Ecuador', response.body
  end

  test "get new category page and reject invalid category submission" do
    get '/categories/new'
    assert_response :success
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: " " } }
    end
    assert_match 'An error occurred', response.body
    assert_select 'div.alert-danger'
    assert_select 'h3.alert-heading'
  end
end
