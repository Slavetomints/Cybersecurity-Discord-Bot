# frozen_string_literal: true

require 'discordrb'
require 'dotenv/load'
require_relative 'lib/commands'

TOKEN = ENV['DISCORD_BOT_TOKEN']
CLIENT_ID = ENV['DISCORD_CLIENT_ID']

bot = Discordrb::Commands::CommandBot.new(
  token: TOKEN,
  client_id: CLIENT_ID.to_i,
  prefix: '!'
)

register_commands(bot)

bot.run
