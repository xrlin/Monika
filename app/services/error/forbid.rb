module Error
        
    class Forbid < BaseError
        def initialize(message = "forbidden")
          @message = message
        end
    end
end