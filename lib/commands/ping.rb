def register_ping_command(bot)
  bot.command(:ping, description: "Checks bot latency.") do |event|
    start_time = Time.now
    message = event.respond "Pinging..."
    latency = ((Time.now - start_time) * 1000).round(2)
    message.edit "Pong! 🏓 Latency: #{latency}ms"
  end
end