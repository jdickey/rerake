
module Rerake
  module Parser
    # Parses Flay statistics reported with test output.
    class Flay
      # Internal methods not affecting or depending on instance state.
      module Internals
        def self.first_match_from_lines(report_lines, regexp)
          report_lines.grep(regexp).first
        end

        def self.matcher
          /Total score \(lower is better\) = (\d+)/
        end
      end
      private_constant :Internals

      attr_reader :counts

      def initialize(report_lines)
        @report_lines = report_lines
        @counts = initial_counts
        self
      end

      def parse
        return self unless detail_line
        assign_counts
        self
      end

      private

      attr_reader :report_lines

      def assign_count(index, value)
        @counts[indexes[index].to_sym] = value
      end

      def assign_counts
        values.each_with_index { |value, index| assign_count index, value }
      end

      def captures
        detail_line.match(Internals.matcher).captures
      end

      def detail_line
        @detail_line ||= Internals.first_match_from_lines Array(report_lines),
                                                          Internals.matcher
      end

      def detail_line_part_strings
        ['total_score']
      end

      def indexes
        @indexes ||= detail_line_part_strings.map(&:to_sym)
      end

      def initial_count_values
        Array(0) * indexes.count
      end

      def initial_counts
        Struct.new(*indexes).new *initial_count_values
      end

      def values
        captures.map(&:to_i)
      end
    end # class Rerake::Parser::Flay
  end
end
