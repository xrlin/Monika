module UserServiceTest
    class RegisterTest < ActiveSupport::TestCase
        test "registering requires password confirmation" do
            service = UserService::Register.new(username: "test", password: "testpassword")
            u = service.perform
            assert u.errors[:password_confirmation].present?
        end
    end
end
