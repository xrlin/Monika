require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include SignInHelper
  test "new require login" do
    get new_post_path
    assert_response :redirect
  end

  test "edit require login" do
    get edit_post_path posts(:post1)
    assert_response :redirect
  end

  test 'get new path success' do
    sign_in_as users(:user1), "password"
    get new_post_path
    assert_response :ok
  end

  test 'edit new path success' do
    sign_in_as users(:user1), "password"
    get edit_post_path posts(:post1)
    assert_response :ok
  end


end
