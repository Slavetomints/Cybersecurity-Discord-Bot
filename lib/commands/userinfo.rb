# frozen_string_literal: true

module CyberSecBot
  module Commands
    def self.register_userinfo_command(bot)
      bot.command(:userinfo, description: 'Displays your username, user info, and ID.') do |event|
        event.respond "Username: #{event.user.name}\n" \
                      "#{event.user.mention}\n" \
                      "User ID: #{event.user.id}"
      end
    end
  end
end
