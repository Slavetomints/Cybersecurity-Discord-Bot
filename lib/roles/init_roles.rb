# frozen_string_literal: true

require 'json'
require 'dotenv'

require_relative 'add'
require_relative 'remove'

module CyberSecBot
  module Roles
    Dotenv.load('config/.env')

    ANNOUNCEMENTS_ROLE_ID = ENV.fetch('ANNOUNCEMENTS_ROLE_ID', nil)
    CHANNEL_ID = ENV.fetch('ROLES_CHANNEL_ID', nil)
    ANNOUNCEMENTS_ROLE_EMOJI = ENV.fetch('ANNOUNCEMENTS_ROLE_EMOJI', nil)
    DAILY_CHALLENGES_ROLE_EMOJI = ENV.fetch('DAILY_CHALLENGES_ROLE_EMOJI', nil)
    DAILY_CHALLENGES_ROLE_ID = ENV.fetch('DAILY_CHALLENGES_ROLE_ID', nil)
    ROLE_MESSAGE_FILE = 'config/role_message_id.json'
    # Retrieves the saved role message ID from a file
    def self.load_message_id
      return nil unless File.exist?(ROLE_MESSAGE_FILE)

      file_data = JSON.parse(File.read(ROLE_MESSAGE_FILE))
      file_data['message_id']
    end

    # Saves the role message ID to a file
    def self.save_message_id(message_id)
      File.write(ROLE_MESSAGE_FILE, JSON.generate({ 'message_id' => message_id }))
      puts "Role selection message ID saved: #{message_id}"
    end

    # Sends a new role selection message and stores the message ID, if needed
    def self.send_role_message(channel, message_id = nil)
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

    def self.init_roles(bot)
      bot.ready do
        channel = bot.channel(CHANNEL_ID)
        role_message_id = load_message_id
        message = send_role_message(channel, role_message_id)

        # Register commands with the correct message ID

        CyberSecBot::Roles.register_add_role(bot, DAILY_CHALLENGES_ROLE_ID, message.id, DAILY_CHALLENGES_ROLE_EMOJI)
        CyberSecBot::Roles.register_remove_role(bot, DAILY_CHALLENGES_ROLE_ID, message.id, DAILY_CHALLENGES_ROLE_EMOJI)

        CyberSecBot::Roles.register_add_role(bot, ANNOUNCEMENTS_ROLE_ID, message.id, ANNOUNCEMENTS_ROLE_EMOJI)
        CyberSecBot::Roles.register_remove_role(bot, ANNOUNCEMENTS_ROLE_ID, message.id, ANNOUNCEMENTS_ROLE_EMOJI)
      end
    end
  end
end
