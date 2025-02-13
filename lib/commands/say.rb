# frozen_string_literal: true

def register_say_command(bot)
  bot.command(:say, description: 'Repeats whatever you say.') do |event, *args|
    event.respond args.join(' ')
  end
end
