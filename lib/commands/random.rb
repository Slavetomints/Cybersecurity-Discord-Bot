# frozen_string_literal: true

def register_random_command(bot)
  bot.command(:random, description: 'Generates a random number between the given min and max.') do |_event, min, max|
    return '🎲 Random number: 42' if min.nil? && max.nil?

    "🎲 Random number: #{rand(min.to_i..max.to_i)} #{min}  #{max}"
  end
end
