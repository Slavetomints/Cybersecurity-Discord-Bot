# frozen_string_literal: true

module CyberSecBot
  module Commands
    def self.register_avatar_command(bot)
      bot.command(:avatar, description: 'Gets your avatar URL.') do |event|
        event.respond event.user.avatar_url
      end
    end
  end
end
