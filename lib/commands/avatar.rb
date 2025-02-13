# frozen_string_literal: true

def register_avatar_command(bot)
  bot.command(:avatar, description: 'Gets your avatar URL.') do |event|
    event.respond event.user.avatar_url
  end
end
