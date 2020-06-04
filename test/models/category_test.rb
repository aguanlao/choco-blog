require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def setup
    @category = Category.new(name: "Madagascar")
  end

  test "category must be valid" do
    assert @category.valid?
  end

  test "name should be present" do
    @category.name = " "
    assert_not @category.valid?
  end

  test "name should be unique" do
    @category.save
    @category2 = Category.new(name: "Madagascar")
    assert_not @category2.valid?
  end

  test "name should be shorter than 26" do
    @category.name = "a" * 26
    assert_not @category.valid?
  end

  test "name should be longer than 2" do
    @category.name = "aa"
    assert_not @category.valid?
  end
end