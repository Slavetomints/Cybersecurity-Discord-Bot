# frozen_string_literal: true

require 'discordrb'
require 'spec_helper'
require_relative '../lib/roles/add'
require_relative '../lib/roles/remove'

RSpec.describe CyberSecBot::Roles do
  let(:bot) { instance_double(Discordrb::Commands::CommandBot) }
  let(:event) do
    instance_double(
      Discordrb::Events::ReactionAddEvent,
      message: instance_double(Discordrb::Message, id: 12_345),
      emoji: instance_double(Discordrb::Emoji, name: '✅'),
      user: user,
      server: server
    )
  end
  let(:user) { instance_double(Discordrb::Member, name: 'TestUser') }
  let(:server) { instance_double(Discordrb::Server, roles: [role]) }
  let(:role) { instance_double(Discordrb::Role, id: 67_890, name: 'TestRole') }

  before do
    allow(user).to receive(:add_role)
    allow(user).to receive(:remove_role)
  end

  describe '.valid_reaction?' do
    it 'returns true for a valid reaction' do
      expect(CyberSecBot::Roles.valid_reaction?(event, 12_345, '✅')).to be true
    end

    it 'returns false for an invalid message ID' do
      expect(CyberSecBot::Roles.valid_reaction?(event, 54_321, '✅')).to be false
    end

    it 'returns false for an invalid emoji' do
      expect(CyberSecBot::Roles.valid_reaction?(event, 12_345, '❌')).to be false
    end
  end

  describe '.assign_role' do
    it 'assigns the role to the user' do
      expect(user).to receive(:add_role).with(role)
      expect do
        CyberSecBot::Roles.assign_role(user, server, 67_890)
      end.to output(/Added role TestRole to TestUser/).to_stdout
    end

    it 'logs an error message when the role is not found' do
      allow(server).to receive(:roles).and_return([])
      expect do
        CyberSecBot::Roles.assign_role(user, server, 67_890)
      end.to output(/Role with ID 67890 not found!/).to_stdout
    end
  end

  describe '.remove_role' do
    it 'removes the role from the user' do
      expect(user).to receive(:remove_role).with(role)
      expect do
        CyberSecBot::Roles.remove_role(user, server, 67_890)
      end.to output(/Removed role TestRole from TestUser/).to_stdout
    end

    it 'logs an error message when the role is not found' do
      allow(server).to receive(:roles).and_return([])
      expect do
        CyberSecBot::Roles.remove_role(user, server, 67_890)
      end.to output(/Role not found!/).to_stdout
    end
  end

  describe '.register_add_role' do
    it 'registers a reaction_add event' do
      expect(bot).to receive(:reaction_add)
      CyberSecBot::Roles.register_add_role(bot, 67_890, 12_345, '✅')
    end

    it 'calls assign_role when the reaction is valid' do
      allow(bot).to receive(:reaction_add).and_yield(event)
      expect(CyberSecBot::Roles).to receive(:assign_role).with(user, server, 67_890)
      CyberSecBot::Roles.register_add_role(bot, 67_890, 12_345, '✅')
    end
  end

  describe '.register_remove_role' do
    it 'registers a reaction_remove event' do
      expect(bot).to receive(:reaction_remove)
      CyberSecBot::Roles.register_remove_role(bot, 67_890, 12_345, '✅')
    end

    it 'calls remove_role when the reaction is valid' do
      allow(bot).to receive(:reaction_remove).and_yield(event)
      expect(CyberSecBot::Roles).to receive(:remove_role).with(user, server, 67_890)
      CyberSecBot::Roles.register_remove_role(bot, 67_890, 12_345, '✅')
    end
  end
end
