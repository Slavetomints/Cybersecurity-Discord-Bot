# frozen_string_literal: true

require 'json'

module CyberSecBot
  module Scripts
    def self.collect_bandit_challenges(level_array)
      first_level = 'bandit0'
      levels_information = {}
      level_array.each do |level|
        level = formatted_level(level)
        level.gsub!(first_level, '')
        next if level.empty? || level == 'bandit'

        first_level = level

        challenge_information = collect_level_information(Nokogiri::HTML(URI.open("https://overthewire.org/wargames/bandit/#{first_level}.html")))
        levels_information[level] = challenge_information
      end
      JSON.pretty_generate(levels_information)
    end

    def self.formatted_level(level)
      level = level.text
                   .gsub(' ', '')
                   .encode('ASCII', invalid: :replace, undef: :replace, replace: '')
                   .downcase

      level.gsub!('level', 'bandit')
      level
    end

    def self.collect_level_information(doc)
      info_hash = {}

      # Extract the level goal description (within <h2> and <p> tags)
      level_goal_section = doc.at_css('#level-goal + p')
      info_hash['description'] =
        level_goal_section ? level_goal_section.text.gsub("\n", ' ').strip : 'No description available.'

      # Extract commands listed under "Commands you may need to solve this level"
      commands_section = doc.at_css('#commands-you-may-need-to-solve-this-level + p')
      commands_text = commands_section ? commands_section.css('a').map { |link| link.text.strip } : []
      info_hash['commands'] = commands_text

      # Extract helpful reading, which are the links inside <p> tags
      helpful_reading = doc.css('p a').map { |link| link['href'] }
      info_hash['helpful_reading'] = helpful_reading

      info_hash
    end
  end
end
