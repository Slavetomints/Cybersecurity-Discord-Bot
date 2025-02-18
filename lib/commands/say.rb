# frozen_string_literal: true

module CyberSecBot
  module Commands
    def self.register_say_command(bot)
      bot.command(:say, description: 'Repeats whatever you say.') do |event, *args|
        event.respond args.join(' ')
      end
    end
  end
end
