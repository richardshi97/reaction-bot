#!/usr/bin/env ruby

# For HTML unescaping
require 'cgi'

module ReactionBot
  module Commands
    # Adds key values to data store
    class Add < SlackRubyBot::Commands::Base
      command 'add'

      # Extracts full URL string from Slacks formatted URL
      def self.extract_url(text_url)
        # text_url.gsub!(/\\u([a-f0-9]{4,5})/i){ [$1.hex].pack('U') }
        CGI.unescapeHTML(/<(?<url>[^>\|]+)(?:\|([^>]+))?>/.match(text_url)[:url])
      end

      def self.call(client, data, match)
        if match[:expression]
          params = match[:expression].rpartition(' ')
          trigger = params.first
          link = params.last
          if !trigger.nil? && !link.nil?
            Respond.add_to_matches(client.team.name, trigger, extract_url(link))
            client.say(channel: data.channel, text: "Successfully added image for trigger '#{trigger}'")
          else
            client.say(channel: data.channel, text: "Error: Hey, you're missing a reaction <image> link for me to post.")
          end
        else
          client.say(channel: data.channel, text: 'Error: Please give me a <trigger> word and a <image> link.')
        end
      end
    end
  end
end
