require_relative "twitch_classes"

puts "Welcome to twitch-cmd app"

page = Page.new()

help = File.open("help").read

while true
    print ">"
    input = gets.chomp
    break if input == 'quit'
    puts help if input == "help"
    puts page.dispatch(input)
end