# frozen_string_literal: true

require_relative 'commands/avatar'
require_relative 'commands/flip'
require_relative 'commands/help'
require_relative 'commands/ping'
require_relative 'commands/random'
require_relative 'commands/roll'
require_relative 'commands/say'
require_relative 'commands/serverinfo'
require_relative 'commands/userinfo'

require_relative 'roles/init_roles'

module CyberSecBot
  def self.register_commands(bot)
    CyberSecBot::Commands.register_avatar_command(bot)
    CyberSecBot::Commands.register_flip_command(bot)
    CyberSecBot::Commands.register_help_command(bot)
    CyberSecBot::Commands.register_ping_command(bot)
    CyberSecBot::Commands.register_random_command(bot)
    CyberSecBot::Commands.register_roll_command(bot)
    CyberSecBot::Commands.register_say_command(bot)
    CyberSecBot::Commands.register_serverinfo_command(bot)
    CyberSecBot::Commands.register_userinfo_command(bot)
    CyberSecBot::Roles.init_roles(bot)
  end
end
