class FlowController < ApplicationController
    def index
        page = (params[:page] || 1).to_i
        if params[:type] == 'article'
            infos = EssayService::Flow.retrieve_articles_with_latest_comments page
        elsif params[:type] == 'post'
            infos = EssayService::Flow.retrieve_posts_with_latest_comments page
        else
            infos = EssayService::Flow.retrieve_activities page
        end

        respond_to do |format|
            format.html {
                render locals: {essays: infos[:essays], comment_groups: infos[:comment_groups], next_page: page + 1}
            }
            format.json {
                render json: {
                    html: render_to_string(
                        partial: 'index',
                        formats: :html,
                        layout: false,
                        locals: {essays: infos[:essays], comment_groups: infos[:comment_groups], next_page: page + 1}
                    )
                }
            }
        end
    end

end
