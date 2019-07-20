require 'test_helper'

class VotesControllerTest < ActionDispatch::IntegrationTest
  include SignInHelper

  test "vote require login" do
    article = articles(:article1)
    post votes_path(essay_id: article.id, essay_type: article.class.name), as: :json
    ret = JSON.parse @response.body
    assert ret['error'].present?
  end

  test 'cannot vote twice' do
    article = articles(:article1)
    user = users(:user1)
    sign_in_as user, 'password'
    assert_difference 'article.weighted_score', +1 do
      post votes_path(essay_id: article.id, essay_type: article.class.name), as: :json
      article.reload
    end

    assert_no_changes 'article.weighted_score' do
      post votes_path(essay_id: article.id, essay_type: article.class.name), as: :json
      article.reload
    end
  end
end
