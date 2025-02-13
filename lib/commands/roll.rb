def register_roll_command(bot)
  bot.command(:roll, description: "Rolls a dice with the specified number of sides (default is 6).") do |event, sides = 6|
    "🎲 You rolled a #{rand(1..sides.to_i)}!"
  end
end