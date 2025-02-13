def register_help_command(bot)
  bot.command(:help, description: "this cruft") do |event|
    help_text = "**Available Commands:**\n"
    bot.commands.each do |name, command|
      help_text += "`!#{name}` - #{command.attributes[:description] || 'No description available'}\n"
    end
    event.respond help_text
  end
end