require_relative "twitch_classes"

puts "Welcome to twitch-cmd app"

page = Page.new()

while true
    print ">"
    input = gets.chomp
    break if input == 'quit'
    puts page.dispatch(input)
end