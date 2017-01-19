require 'time'
require 'json'

module Fluent
  class TextParser
    class ForemanParser < Parser
      Plugin.register_parser('foreman', self)

      TIME_REGEX = '\A\d\d:\d\d:\d\d'.freeze
      SERVICE_NAME_REGEX = '(\S+)\s+\|'.freeze
      MESSAGE_REGEX = '\|\s(.*)'.freeze

      config_param :time_format, :string, default: nil

      def configure(conf)
        super
        @time_parser = TimeParser.new @time_format
      end

      def parse(input)
        time = @time_parser.parse match_time(input)

        output = {
          service: match_service(input),
          log: match_message(input)
        }

        yield time, output
      end

      private

      def match_time(input)
        match = input.match TIME_REGEX
        time = match ? Time.parse(match[0]) : Time.now

        time.strftime @time_format
      end

      def match_service(input)
        match = input.match SERVICE_NAME_REGEX
        match ? match[1] : nil
      end

      def match_message(input)
        match = input.match MESSAGE_REGEX
        match ? match[1] : nil
      end
    end
  end
end
