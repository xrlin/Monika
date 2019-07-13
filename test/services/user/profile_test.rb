module UserServiceTest
    class ProfileTest < ActiveSupport::TestCase
        test "update profile except password" do
            u = UserService::Profile.update_profile("user1", avatar_link: "http://test.avatar")
            assert u.errors.blank?
        end

        test "update profile with wrong old password" do
            u = UserService::Profile.update_profile("user1", avatar_link: "http://test.avatar", old_password: "wrong")
            assert u.errors[:password].present?
        end

        test "update profile without password confirmation" do
            u = UserService::Profile.update_profile("user1", 
                avatar_link: "http://test.avatar", old_password: "password", new_password: "password2")
            assert u.errors[:password].present?
        end

        test "update profile with wrong confirmation" do
            u = UserService::Profile.update_profile("user1", avatar_link: "http://test.avatar",
                 old_password: "password", new_password: "password2", password_confirmation: "wrong")
            assert u.errors[:password].present?
        end

    end
end
