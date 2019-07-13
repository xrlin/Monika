module UserService
    #
    # Update/Retrieve user's profile
    #
    class Profile

        PASSWORD_FIELDS = %i[old_password new_password password_confirmation].freeze


        class << self 
            #
            # Return user's profile
            #
            # @param [string] username 
            #
            # @return [User]
            #
            def retrieve_profile(username)
                User.find_by! username: username
            end

            #
            # Update user's profile (including password if present)
            #
            # @param [String] username user's current username
            # @param [Has] **params user attributes, all keys are symbol
            #
            # @return [User] User object with updated attributes, raise exception if user not found,
            #                use errors attribute to check success
            def update_profile(username, **params)
                u = User.find_by!(username: username)
                update_params = params_except_password_fields params
                if should_update_password?(params)
                    if auth?(u, params[:old_password])
                        update_params[:password] = params[:new_password]
                        update_params[:password_confirmation] = params[:password_confirmation] || ""
                    else
                        u.errors.add(:password, "is invalid")
                        return u
                    end
                end
                u.update(update_params)
                u
            end

            private

            def auth?(user, old_password)
                user.authenticate(old_password) ? true : false 
            end

            def should_update_password?(params)
                PASSWORD_FIELDS.any? {|key| params[key].present?}
            end

            #
            #
            # @param [Hash] parmas 
            #
            # @return [Hash] 
            #
            def params_except_password_fields(params)
                params.reject {|k, _| PASSWORD_FIELDS.include?(k)}
            end
        
        end       
       
    end
end