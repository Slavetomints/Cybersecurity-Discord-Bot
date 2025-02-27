# frozen_string_literal: true

module CyberSecBot
  module Commands
    def self.register_serverinfo_command(bot)
      bot.command(:serverinfo, description: 'Displays the server name and member count.') do |event|
        server = event.server
        "Server Name: #{server.name}\nMember Count: #{server.member_count}"
      end
    end
  end
end
