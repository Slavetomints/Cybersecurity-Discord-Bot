# frozen_string_literal: true

require 'dotenv'
require 'json'
require 'fileutils'

Dotenv.load('../config/.env')

csrf_token = ENV['CSRF_TOKEN']
session_id = ENV['SESSION_ID']
cf_clearance = ENV['CF_CLEARANCE']
challenge_files = []
FileUtils.touch('master_challenges.json')

def call_for_challenges(number, csrf_token, session_id, cf_clearance)
  output_file = "picoctf_page_#{number}.json"

  curl_command = %(
    curl -s 'https://play.picoctf.org/api/challenges/?page_size=100&page=#{number}' \\
         -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:128.0) Gecko/20100101 Firefox/128.0' \\
         -H 'Accept: application/json, text/plain, */*' \\
         -H 'Accept-Encoding: gzip, deflate, br, zstd' \\
         -H 'Referer: https://play.picoctf.org/practice?page=#{number}' \\
         -H 'X-CSRFToken: #{csrf_token}' \\
         -H 'DNT: 1' \\
         -H 'Sec-GPC: 1' \\
         -H 'Connection: keep-alive' \\
         -H 'Cookie: csrftoken=#{csrf_token}; sessionid=#{session_id}; cf_clearance=#{cf_clearance}' \\
         --compressed -o #{output_file}
  )
  system(curl_command)
  puts "Saved Page #{number} to #{output_file}"
end

def clean_page(number)
  file_path = "picoctf_page_#{number}.json"

  return unless File.exist?(file_path)

  # Check for "Invalid page" response
  if File.foreach(file_path).grep(/{"detail":"Invalid page."}/).any?
    File.delete(file_path)
    puts "Deleted invalid page: #{file_path}"
    return true
  end

  # Load JSON and extract only 'results'
  data = JSON.parse(File.read(file_path))
  return true unless data['results'] # Skip if 'results' key is missing

  File.write(file_path, JSON.pretty_generate(data['results']))
  false
end

# Fetch and clean challenge pages
(1..10).each do |number|
  call_for_challenges(number, csrf_token, session_id, cf_clearance)
  next if clean_page(number)

  challenge_files << "picoctf_page_#{number}.json"
end

# Update the challenges with descriptions and hints
def update_challenge_details(master_file, csrf_token, session_id, cf_clearance)
  # Read the master challenges file
  master_data = JSON.parse(File.read(master_file))

  master_data.each do |challenge|
    challenge_id = challenge['id']

    # Skip if the challenge doesn't have an id
    next unless challenge_id

    # Fetch challenge details (description and hints)
    output_file = "#{challenge_id}_desc.json"

    # Perform the curl request to get challenge details
    puts "Getting #{challenge_id} description"
    curl_command = %(
      curl -s 'https://play.picoctf.org/api/challenges/#{challenge_id}/instance/' \
           -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:128.0) Gecko/20100101 Firefox/128.0' \
           -H 'Accept: application/json, text/plain, */*' \
           -H 'X-CSRFToken: #{csrf_token}' \
           -H 'Cookie: csrftoken=#{csrf_token}; sessionid=#{session_id}; cf_clearance=#{cf_clearance}' \
           --compressed -o #{output_file}
    )
    system(curl_command)

    # Parse the response from the curl output file
    if File.exist?(output_file)
      begin
        response_data = JSON.parse(File.read(output_file))
        description = response_data['description'] || 'N/A'
        hints = response_data['hints'] || []

        # Remove <p> and </p> tags from description and hints using regex
        description = description.gsub(%r{<p>|</p>}, '').strip
        hints = hints.map { |hint| hint.gsub(%r{<p>|</p>}, '').strip }

        # Add the description and hints to the challenge data
        challenge['description'] = description
        challenge['hints'] = hints
      rescue JSON::ParserError => e
        puts "Error parsing the response for challenge #{challenge_id}: #{e.message}"
        challenge['description'] = 'Error fetching description'
        challenge['hints'] = []
      end

      # Clean up by deleting the temporary challenge description file
      File.delete(output_file)
    else
      puts "No description file for challenge #{challenge_id}. Skipping..."
    end
  end

  # Write the updated data back to the master challenges file
  File.write(master_file, JSON.pretty_generate(master_data))
  puts 'Updated master challenges file with descriptions and hints.'
end

def clean_challenge_data(master_file)
  # Read the master challenges file
  master_data = JSON.parse(File.read(master_file))

  # Define the keys that should be retained in the cleaned challenge data
  retained_keys = %w[
    id name author difficulty event category tags
    description hints url
  ]

  master_data.each do |challenge|
    # Remove all keys that are not in the retained_keys list
    challenge.each_key do |key|
      challenge.delete(key) unless retained_keys.include?(key)
    end

    # Add the "url" key with the specified URL format
    challenge['url'] = "https://play.picoctf.org/practice/challenge/#{challenge['id']}"
  end

  # Write the cleaned data back to the master challenges file
  File.write(master_file, JSON.pretty_generate(master_data))
  puts 'Cleaned up and updated master challenges file with URL.'
end

def move_master_challenges(master_file, location)
  # Copy the master file to the new location
  FileUtils.cp(master_file, location)

  # Delete the original master file
  File.delete(master_file)

  puts "Moved '#{master_file}' to '#{location}' and deleted the original."
end

def count_challenges(master_file)
  # Read the master challenges file
  master_data = JSON.parse(File.read(master_file))

  # Count the number of challenges
  count = master_data.count

  puts "Total challenges saved: #{count}"
  count
end

# Merge all cleaned JSON files into a master file
master_file = 'master_challenges.json'
master_data = []

challenge_files.each do |filename|
  next unless File.exist?(filename)

  file_data = JSON.parse(File.read(filename))
  master_data.concat(file_data)
  File.delete(filename)
end
File.write(master_file, JSON.pretty_generate(master_data))

# Call the function to update challenge details
update_challenge_details(master_file, csrf_token, session_id, cf_clearance)
clean_challenge_data('master_challenges.json')
count_challenges(master_file)
move_master_challenges(master_file, '../database/pico_ctf_challenges.json')

puts "Merged #{challenge_files.count} files into #{master_file} and updated challenges with descriptions and hints."
