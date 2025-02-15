# frozen_string_literal: true

require_relative 'add'
require_relative 'remove'
require 'json'
require 'dotenv/load'

ANNOUNCEMENTS_ROLE_ID = ENV['ANNOUNCEMENTS_ROLE_ID'] # Test role ID
CHANNEL_ID = ENV['ROLES_CHANNEL_ID'] # #roles channel ID
ANNOUNCEMENTS_ROLE_EMOJI = ENV['ANNOUNCEMENTS_ROLE_EMOJI'] # Green circle emoji
DAILY_CHALLENGES_ROLE_EMOJI = ENV['DAILY_CHALLENGES_ROLE_EMOJI']
DAILY_CHALLENGES_ROLE_ID = ENV['DAILY_CHALLENGES_ROLE_ID']
ROLE_MESSAGE_FILE = 'role_message_id.json' # File to store the message ID

# Retrieves the saved role message ID from a file
def load_message_id
  return nil unless File.exist?(ROLE_MESSAGE_FILE)

  file_data = JSON.parse(File.read(ROLE_MESSAGE_FILE))
  file_data['message_id']
end

# Saves the role message ID to a file
def save_message_id(message_id)
  File.write(ROLE_MESSAGE_FILE, JSON.generate({ 'message_id' => message_id }))
  puts "Role selection message ID saved: #{message_id}"
end

# Sends a new role selection message and stores the message ID, if needed
def send_role_message(channel, message_id = nil) # rubocop:disable Metrics/MethodLength
  if message_id
    puts 'Using existing message ID'
    channel.message(message_id)
  else
    message = channel.send_message("If you want to get Announcements, please react with #{ANNOUNCEMENTS_ROLE_EMOJI}\nIf you want to receive daily challenges, please react with #{DAILY_CHALLENGES_ROLE_EMOJI}") # rubocop:disable Layout/LineLength
    message.react(ANNOUNCEMENTS_ROLE_EMOJI)
    message.react(DAILY_CHALLENGES_ROLE_EMOJI)
    save_message_id(message.id)
    puts 'Role selection message sent and ID saved'
    message
  end
end

def init_roles(bot)
  bot.ready do
    channel = bot.channel(CHANNEL_ID)
    role_message_id = load_message_id
    message = send_role_message(channel, role_message_id)

    # Register commands with the correct message ID

    register_add_role(bot, DAILY_CHALLENGES_ROLE_ID, message.id, DAILY_CHALLENGES_ROLE_EMOJI)
    register_remove_role(bot, DAILY_CHALLENGES_ROLE_ID, message.id, DAILY_CHALLENGES_ROLE_EMOJI)

    register_add_role(bot, ANNOUNCEMENTS_ROLE_ID, message.id, ANNOUNCEMENTS_ROLE_EMOJI)
    register_remove_role(bot, ANNOUNCEMENTS_ROLE_ID, message.id, ANNOUNCEMENTS_ROLE_EMOJI)
  end
end
