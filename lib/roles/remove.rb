# frozen_string_literal: true

def register_remove_role(bot)
  bot.reaction_remove do |event|
    role_id = 1_339_633_352_440_938_618
    user = event.user
    server = event.server

    next if user.bot?

    role = server.roles.find { |r| r.id == role_id }
    if role
      event.user.remove_role(role)
      puts "Removed role #{role.name} from #{user.name}"
    else
      puts 'Role not found!'
    end
  end
end
