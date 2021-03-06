require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  include SignInHelper
  test "new require login" do
    get new_article_path
    assert_response :redirect
  end

  test "edit require login" do
    get edit_article_path articles(:article1)
    assert_response :redirect
  end

  test 'get new path success' do
    sign_in_as users(:user1), "password"
    get new_article_path
    assert_response :ok
  end

  test 'edit new path success' do
    sign_in_as users(:user1), "password"
    get edit_article_path articles(:article1)
    assert_response :ok
  end


end
