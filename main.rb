require 'discordrb'
require 'dotenv/load'
require_relative 'lib/commands'

TOKEN = ENV['DISCORD_BOT_TOKEN']
CLIENT_ID = ENV['DISCORD_CLIENT_ID']
bot = Discordrb::Commands::CommandBot.new(
  token: TOKEN,
  client_id: CLIENT_ID.to_i,
  prefix: '!',
)

Dir["#{File.dirname(__FILE__)}/lib/commands/*.rb"].each { | file | load file }

register_commands(bot)

bot.run
