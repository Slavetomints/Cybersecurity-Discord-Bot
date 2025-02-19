# frozen_string_literal: true

require 'discordrb'
require 'spec_helper'
require_relative '../lib/commands/avatar'
require_relative '../lib/commands/flip'
require_relative '../lib/commands/help'
require_relative '../lib/commands/ping'
require_relative '../lib/commands/random'
require_relative '../lib/commands/roll'
require_relative '../lib/commands/say'
require_relative '../lib/commands/serverinfo'
require_relative '../lib/commands/userinfo'

RSpec.describe CyberSecBot::Commands do
  let(:bot) { instance_double(Discordrb::Commands::CommandBot) }
  let(:event) { instance_double(Discordrb::Commands::CommandEvent) }

  before do
    allow(bot).to receive(:command)
  end

  describe '.register_avatar_command' do
    it 'registers the avatar command' do
      expect(bot).to receive(:command).with(:avatar, description: 'Gets your avatar URL.')
      CyberSecBot::Commands.register_avatar_command(bot)
    end
  end

  describe '.register_flip_command' do
    it 'registers the flip command' do
      expect(bot).to receive(:command).with(:flip, description: 'Flips a coin and returns Heads or Tails.')
      CyberSecBot::Commands.register_flip_command(bot)
    end
  end

  describe '.register_help_command' do
    it 'registers the help command' do
      expect(bot).to receive(:command).with(:help, description: 'this cruft')
      CyberSecBot::Commands.register_help_command(bot)
    end
  end

  describe '.register_ping_command' do
    it 'registers the ping command' do
      expect(bot).to receive(:command).with(:ping, description: 'Checks bot latency.')
      CyberSecBot::Commands.register_ping_command(bot)
    end
  end

  describe '.register_random_command' do
    it 'resisters the random command' do
      expect(bot).to receive(:command).with(:random,
                                            description: 'Generates a random number between the given min and max.')
      CyberSecBot::Commands.register_random_command(bot)
    end
  end

  describe '.register_roll_command' do
    it 'registers the roll command' do
      expect(bot).to receive(:command).with(:roll,
                                            description: 'Rolls a dice with the specified number of sides (default is 6).')
      CyberSecBot::Commands.register_roll_command(bot)
    end
  end

  describe '.register_say_command' do
    it 'registers the say command' do
      expect(bot).to receive(:command).with(:say, description: 'Repeats whatever you say.')
      CyberSecBot::Commands.register_say_command(bot)
    end
  end

  describe '.register_serverinfo_command' do
    it 'registers the serverinfo command' do
      expect(bot).to receive(:command).with(:serverinfo, description: 'Displays the server name and member count.')
      CyberSecBot::Commands.register_serverinfo_command(bot)
    end
  end

  describe '.register_userinfo_command' do
    it 'registers the userinfo command' do
      expect(bot).to receive(:command).with(:userinfo, description: 'Displays your username, user info, and ID.')
      CyberSecBot::Commands.register_userinfo_command(bot)
    end
  end
end
