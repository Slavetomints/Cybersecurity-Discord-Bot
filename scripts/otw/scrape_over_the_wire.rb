# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'json'

require_relative 'abraxas'
require_relative 'bandit'
require_relative 'behemoth'
require_relative 'drifter'
require_relative 'formulaone'
require_relative 'hes2010'
require_relative 'kishi'
require_relative 'krypton'
require_relative 'leviathan'
require_relative 'manpage'
require_relative 'maze'
require_relative 'monxla'
require_relative 'narnia'
require_relative 'natas'
require_relative 'semtex'
require_relative 'utumno'
require_relative 'vortex'

module CyberSecBot
  module Scripts
    def self.scrape_wargames
      wargames = {}
      base_url = 'https://overthewire.org/wargames/'

      base_document = Nokogiri::HTML(URI.open(base_url))

      base_document.css('div#sidemenu li a').each do |link|
        game = link.text.strip
        next if ['Wargames', 'Information', 'Rules', ''].include?(game)

        wargames[game] = {}
      end

      browser = Watir::Browser.new :chrome, headless: true
      wargames.each_key do |game|
        browser.goto "https://overthewire.org/wargames/#{game.downcase}/"
        wargame_document = Nokogiri::HTML.parse(browser.html)
        levels = wargame_document.css('div#sidemenu ul li a').map do |level|
          level
        end
        wargames[game] = send("collect_#{game.downcase}_challenges", levels)
        puts wargames[game]
      end

      File.write('wargames.json', JSON.pretty_generate(wargames))
      puts 'Scraping complete. Data saved to wargames.json'
    end
  end
end

CyberSecBot::Scripts.scrape_wargames
