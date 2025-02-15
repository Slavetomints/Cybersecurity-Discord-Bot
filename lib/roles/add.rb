# frozen_string_literal: true

# Check if the reaction is valid based on message ID and emoji
def valid_reaction?(event, role_message_id, emoji)
  event.message.id == role_message_id && event.emoji.name == emoji
end

# Assign the specified role to the user
def assign_role(user, server, role_id)
  role = server.roles.find { |r| r.id == role_id.to_i }

  if role
    user.add_role(role)
    puts "Added role #{role.name} to #{user.name}"
  else
    # Log error message if the role is not found
    puts "Role with ID #{role_id} not found!"
  end
end

# Register the reaction add event to assign roles
def register_add_role(bot, role_id, role_message_id, emoji)
  bot.reaction_add do |event|
    if valid_reaction?(event, role_message_id, emoji)
      # Assign the role if the reaction is valid
      assign_role(event.user, event.server, role_id)
    end
  end
end
