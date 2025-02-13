def register_flip_command(bot)
  bot.command(:flip, description: "Flips a coin and returns Heads or Tails.") do |event|
    "🪙 #{["Heads", "Tails"].sample}"
  end
end