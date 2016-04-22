require 'json'
require 'uri'

#Session deals with user credentials, and also initializes the other classes
#Also keeps track of what to display to user, and where the user is(on search, on a stream, on a channel, etc.)
class Session
    def initialize
        @location = :main_menu
    end
    
    def dispatch(command)
        command_words = command.split(' ')
        return self.subscriptions if command_words[0] == 'subscriptions'
        
    end
end

#Search stores search data
class Search
end