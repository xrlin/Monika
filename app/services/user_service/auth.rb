module UserService
    class Auth
   
        def initialize(username, password)
            @username = username
            @password = password
        end


        #
        # Check and return the authenticated user
        #
        # @return [User] nil if auth failed or user not found
        #
        def perform
            u = User.find_by(username: @username)
            return u if u.try(:authenticate, @password)
            nil
        end
        
    end
end