
module Rerake
  module Parser
    # Parses RuboCop statistics reported with test output.
    class RuboCop
      # Internal methods not affecting or depending on instance state.
      module Internals
        def self.first_match_from(report_lines)
          Array(report_lines).grep(matcher).first
        end

        def self.matcher
          /(\d+) files inspected, (\S+) offenses detected/
        end
      end
      private_constant :Internals

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

      def captures
        detail_line.match(Internals.matcher).captures
      end

      def detail_line
        @detail_line ||= Internals.first_match_from(report_lines)
      end

      def detail_line_part_strings
        ['files', 'offenses']
      end

      def indexes
        detail_line_part_strings.map(&:to_sym)
      end

      def values
        captures.map(&:to_i)
      end
    end # class Rerake::Parser::RuboCop
  end
end
