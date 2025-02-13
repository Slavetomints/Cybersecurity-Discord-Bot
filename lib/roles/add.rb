# frozen_string_literal: true

def register_add_role(bot)
  bot.reaction_add do |event|
    role_id = 1_339_633_352_440_938_618
    user = event.user
    server = event.server

    next if user.bot?

    role = server.roles.find { |r| r.id == role_id }
    if role
      event.user.add_role(role)
      puts "Added role #{role.name} to #{user.name}"
    else
      puts 'Role not found!'
    end
  end
end
