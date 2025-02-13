# frozen_string_literal: true

def register_flip_command(bot)
  bot.command(:flip, description: 'Flips a coin and returns Heads or Tails.') do |_event|
    "🪙 #{%w[Heads Tails].sample}"
  end
end
