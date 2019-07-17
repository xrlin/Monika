module UserServiceTest
    class AuthTest < ActiveSupport::TestCase
        test "auth success" do
            service = UserService::Auth.new("user1", "password")
            u = service.perform
            assert_not_nil u
        end

        test "auth failed" do
            service = UserService::Auth.new("user1", "wrong password")
            u = service.perform
            assert_not u
        end
    end
end