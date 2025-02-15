# frozen_string_literal: true

def remove_role(user, server, role_id)
  role = server.roles.find { |r| r.id == role_id.to_i }
  if role
    user.remove_role(role)
    puts "Removed role #{role.name} from #{user.name}"
  else
    puts 'Role not found!'
  end
end

def register_remove_role(bot, role_id, role_message_id, emoji)
  bot.reaction_remove do |event|
    next unless valid_reaction?(event, role_message_id, emoji)

    remove_role(event.user, event.server, role_id)
  end
end
