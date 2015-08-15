
module Rerake
  module Parser
    # Parses SimpleCov statistics reported with test output.
    class SimpleCov
      # Internal methods not affecting or depending on instance state.
      module Internals
        def self.call_converter(pair)
          pair.first.send pair.last
        end

        def self.first_match(lines)
          lines.grep(matcher).first
        end

        def self.matcher
          pattern_str = 'Coverage report .+?' \
              ' (\d+) \/ (\d+) LOC' \
              ' \((\d+?\.\d+)%\) covered\.'
          Regexp.new pattern_str
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

      def captures_and_conversions
        conversions = [:to_f, :to_f, :to_i]
        captures.zip(conversions)
      end

      def detail_line
        @detail_line ||= Internals.first_match Array(report_lines)
      end

      def detail_line_part_strings
        ['covered_lines', 'lines', 'coverage']
      end

      def indexes
        detail_line_part_strings.map(&:to_sym)
      end

      def values
        captures_and_conversions.map { |pair| Internals.call_converter pair }
      end
    end # class Rerake::Parser::SimpleCov
  end
end
