def register_random_command(bot)
  bot.command(:random, description: "Generates a random number between the given min and max.") do |event, min, max|
    "🎲 Random number: #{rand(min.to_i..max.to_i)}"
  end
end