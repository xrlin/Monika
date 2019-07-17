module UserService
    class Register
        #
        # Initial register UserService::Register
        #
        # @param [Hash] params a Hash contains users's attribute and value
        #
        def initialize(**params)
          @params = params.dup
          # avoid nil password_confirmation value, which will skip the password validation
          @params[:password_confirmation] ||= ""
        end

        #
        # Create user
        #
        # @return [User], should check the user's errors to check whether save success
        #
        def perform
            u = User.new(@params)
            u.save
            u
        end
        
    end
end