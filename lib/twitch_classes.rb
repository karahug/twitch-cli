require 'json'
require 'open-uri'

PATH = "auth/token.txt"
#Session deals with user credentials, and also initializes the other classes
#Also keeps track of what to display to user, and where the user is(on search, on a stream, on a channel, etc.)
class Page
    attr_accessor :token, :page_number, :page, :data
    def initialize
        @token = File.read(PATH)
        @page_number = 0
        @page = []
        @data = []
    end
    
    def dispatch(command)
        command_words = command.split(' ')
        return self.followed if command_words[0] == 'followed'
        return self.top(command_words[1]) if command_words[0] == 'top'   
        return self.search(command_words[2..-1], command_words[1]) if command_words[0] == 'search' 
        return self.next_page if command_words[0] == 'next'
        return self.prev if command_words[0] == 'prev'
        return self.view(command_words[1]) if command_words[0] == "view"
    end
    
    def followed
        followed = get_followed(self.token)
        get_streams_data(followed)
        self.initialize_page
        self.display
    end
    
    def top(options=nil)
        top = get_top(options)
        if options == "-g"
            get_games_data(top)
        else
            get_streams_data(top)
        end
        self.initialize_page
        self.display
    end
    
    def search(terms, options = nil)
        search = get_search(terms, options)
        if options == "-g" # probably can refactor both get_***_data into one function
            get_games_data(search)
        else
            get_streams_data(search)
        end
        self.initialize_page
        self.display
    end
    
    def next_page
        self.page_number += 1
        self.page = data[(0+10*self.page_number)..(0+10*(self.page_number+1)-1)]
        self.display if self.page != nil
    end
    
    def prev
        if self.page_number > 0
           self.page_number -= 1
           self.page = data[(0+10*self.page_number)..(0+10*(self.page_number+1)-1)]
        end
        self.display if self.page != nil
    end
    
    
   def view(s)
       n = Integer(s)
       selected = self.page[n]
       if selected.keys.include?(:url)
           livestreamer(selected[:url])
       else
           self.search(selected[:game].split(" "))
       end
   end
   
   
   #helper functions
   
    
    def get_followed(token)
        return JSON.parse(open("https://api.twitch.tv/kraken/streams/followed?oauth_token=#{token}&stream_type=live").read)
    end
    
    def get_search(terms, options = nil)
        query = terms.join("+")
        url = nil
        if options == "-g"
            url = "https://api.twitch.tv/kraken/search/games?q=" + query + "&type=suggest"
        else
            url = "https://api.twitch.tv/kraken/search/streams?q=" + query
        end
        return JSON.parse(open(url).read)
    end
    
    def get_top(options = "-g")
        url = nil
        if options == "-g"
            url = "https://api.twitch.tv/kraken/games/top?limit=100"
        else
            url = "https://api.twitch.tv/kraken/streams?limit=100"
        end
        return JSON.parse(open(url).read)
    end
    
    def livestreamer(url, quality = "source")
        cmd = "livestreamer " + url + " " + quality
        system(cmd)
    end
    
    def get_streams_data(raw_data)
        sorted = raw_data["streams"].map { |r|
         {
            streamer: r["channel"]["display_name"],
            status: r["channel"]["status"],
            game: r["channel"]["game"],
            url: r["channel"]["url"]
        }
        }
        self.data = sorted
    end
    
    def get_games_data(raw_data)
        sorted = []
        #different data for top games and search games
        if raw_data.keys.include?("top")
            sorted = raw_data["top"].map {|r|
            {game: r["game"]["name"]}
            }
        else
            sorted = raw_data["games"].map { |r|
             {
                game: r["name"]
            }
            }
        end
        self.data = sorted
    end
    
    def initialize_page
        self.page = self.data[0..9]
        self.page_number = 0
    end
    
    def display
        puts "Page #{self.page_number+1}"
        entry = 0
        self.page.each do |x|
            print "#{entry}: "
            x.keys.each {|k| print  "#{x[k]}    " if k!= :url}
            print "\n"
            entry += 1
        end; nil
        
    end
    
end
