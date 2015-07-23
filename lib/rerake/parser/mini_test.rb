
module Rerake
  module Parser
    # Parses MiniTest (Spec/Unit) output, storing reported count values.
    class MiniTest
      attr_reader :counts

      def initialize(report_lines)
        @report_lines = report_lines
        @counts = {}
        indexes.each { |index| @counts[index] = 0 }
        self
      end

      def parse
        return self unless detail_line
        assign_counts
        self
      end

      private

      attr_reader :report_lines

      def assign_counts
        values.each_with_index do |value, index|
          @counts[indexes[index]] = value
        end
      end

      def detail_line
        @detail_line ||= Array(report_lines).grep(matcher).first
      end

      def matcher
        pattern_str = detail_line_part_strings.map do |what|
          '(\d+?) ' + what
        end.join(', ')[0..-2]
        Regexp.new pattern_str
      end

      def detail_line_part_strings
        ['tests', 'assertions', 'failures', 'errors', 'skips']
      end

      def indexes
        detail_line_part_strings.map(&:to_sym)
      end

      def values
        match_data = detail_line.match matcher
        match_data.captures.map(&:to_i)
      end
    end # class Rerake::Parser::MiniTest
  end
end
