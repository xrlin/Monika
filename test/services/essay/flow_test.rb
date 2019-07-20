module EssayServiceTest
    class FlowTest < ActiveSupport::TestCase
       test "retrieve activities result should order by weighted score, created_at from posts and articles" do
         result = EssayService::Flow.retrieve_activities 1, 2
         essays = result[:essays]
         assert essays.first.weighted_score >= essays.second.weighted_score
         assert essays.first.created_at >= essays.second.created_at
       end

      test "retrieve activities with user" do
        assert_nothing_raised do
          user = users(:user1)
          EssayService::Flow.retrieve_user_activities  user, 1, 2
        end
      end
    end
end