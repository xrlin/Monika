class VotesController < ApplicationController
  before_action :check_login

  def create
    essay_id, essay_type = params.require [:essay_id, :essay_type]
    vote_service = EssayService::Article
    if essay_type == "Post"
      vote_service = EssayService::Post
    end
    score = vote_service.like essay_id, current_user.id

    render json: {
        score: score
    }
  end
end
