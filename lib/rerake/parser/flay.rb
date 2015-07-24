
module Rerake
  module Parser
    # Parses Flay statistics reported with test output.
    class Flay
      # Internal methods not affecting or depending on instance state.
      module Internals
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

      def assign_counts
        values.each_with_index do |value, index|
          @counts[indexes[index].to_sym] = value
        end
      end

      def captures
        detail_line.match(Internals.matcher).captures
      end

      def detail_line
        @detail_line ||= Array(report_lines).grep(Internals.matcher).first
      end

      def detail_line_part_strings
        ['total_score']
      end

      def indexes
        detail_line_part_strings.map(&:to_sym)
      end

      def initial_counts
        ret = Struct.new(*indexes).new
        indexes.each { |index| ret[index] = 0 }
        ret
      end

      def values
        captures.map(&:to_i)
      end
    end # class Rerake::Parser::Flay
  end
end
