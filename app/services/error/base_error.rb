module Error
    
    class BaseError < StandardError
        
        def initialize(message = "")
            @message = message
        end

    end
    
end