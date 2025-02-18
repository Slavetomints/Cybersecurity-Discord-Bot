# frozen_string_literal: true

require 'discordrb'
require 'dotenv'

require_relative 'lib/init_bot_capabilities'

module CyberSecBot
  Dotenv.load('config/.env')

  TOKEN = ENV['DISCORD_BOT_TOKEN']
  CLIENT_ID = ENV['DISCORD_CLIENT_ID']

  bot = Discordrb::Commands::CommandBot.new(
    token: TOKEN,
    client_id: CLIENT_ID.to_i,
    prefix: '!'
  )

  CyberSecBot.register_commands(bot)

  bot.run
end
