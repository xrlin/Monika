class CommentsController < ApplicationController
  def create
    comment_params = params.permit(:essay_id, :essay_type, :content, :reply_to_comment_id)
    arguments = comment_params.to_h.deep_symbolize_keys
    comment = EssayService::Comment.create current_user, arguments[:content], arguments[:essay_id], arguments[:essay_type], arguments[:reply_to_comment_id]
    if comment.errors.present?
      render json: {
          error: comment.errors.full_messages.to_sentence
      }, status: :bad_request
    end
    render json: {
        html: render_to_string(
            partial: 'show',
            formats: :html,
            layout: false,
            locals: { comment: comment }
        )
    }, status: :created
  end

  def index
    essay_id = params[:essay_id]
    essay_type = params[:essay_type]
    comments = EssayService::Comment.comments_with_essay essay_id, essay_type, params[:start]
    render json: {
        html: render_to_string(
            partial: 'index',
            formats: :html,
            layout: false,
            locals: { comments: comments, essay_id: essay_id, essay_type: essay_type }
        )
    }
  end
end
