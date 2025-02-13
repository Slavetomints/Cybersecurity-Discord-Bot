require 'discordrb'
require 'dotenv/load'

TOKEN = ENV['DISCORD_BOT_TOKEN']
CLIENT_ID = ENV['DISCORD_CLIENT_ID']
bot = Discordrb::Commands::CommandBot.new(
  token: TOKEN,
  client_id: CLIENT_ID.to_i,
  prefix: '!',
)

bot.command :help do |event|
  event.respond "**!help** - this cruft\n" \
                "**!ping** - you get ponged\n" \
                "**!random** *[min]* *[max]* - get a random number between min and max"
end

bot.command :userinfo do |event|
  event.respond "Username: #{event.Username}\n" \
                "#{event.userinfo}\n" \
                "ID #{event.user.ID}\n"\
end

bot.command :ping do |event|
  event.respond "Pong! 🏓"
end

bot.command :random do |event, min, max|
  rand(min.to_i..max.to_i)
end

bot.run
