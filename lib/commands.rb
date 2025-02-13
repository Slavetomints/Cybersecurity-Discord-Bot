require_relative 'commands/avatar'
require_relative 'commands/flip'
require_relative 'commands/help'
require_relative 'commands/ping'
require_relative 'commands/random'
require_relative 'commands/roll'
require_relative 'commands/say'
require_relative 'commands/serverinfo'
require_relative 'commands/userinfo'

def register_commands(bot)
  register_avatar_command(bot)
  register_flip_command(bot)
  register_help_command(bot)
  register_ping_command(bot)
  register_random_command(bot)
  register_roll_command(bot)
  register_say_command(bot)
  register_serverinfo_command(bot)
  register_userinfo_command(bot)
end