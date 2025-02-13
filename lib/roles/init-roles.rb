def init_roles(bot)
  ROLE_ID = 1339633352440938618 # Test role ID
  CHANNEL_ID = 1339634261438894233 # #roles channel ID
  EMOJI = "🟢" # Green circle emoji

  bot.ready do
    channel = bot.channel(CHANNEL_ID)
    message = channel.send_message("If you want the \"Test Role\", please react with #{EMOJI}")
    message.react(EMOJI) # Add reaction for users to interact with
    puts "Role selection message sent in #roles"
  end

  register_add_role(bot)
  register_remove_role(bot)
end