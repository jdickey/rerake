
module Rerake
  module Parser
    # Parses Flog statistics reported with test output.
    #
    # Parsing Flog output is different than parsing almost any other tool's
    # output, in that there is a *series* of significant lines. An example
    # follows:
    #   160.1: flog total
    #     4.6: flog/method average
    #
    #     8.6: Foo::Bar::Baz#values   lib/foo/bar/baz.rb:58
    #     8.1: Foo::Bar::Quux#values  lib/foo/bar/quux.rb:50
    #     7.9: Foo::Bar::Quux#matcher lib/foo/bar/quux.rb:35
    #     ...: ...more follows...
    #
    # Note that the blank line after "flog/method average" is included in the
    # original output. So, instead of parsing multiple values out of a single
    # line of output, we instead care about *four* lines, three of which provide
    # score details (total, method average, and maximum score and method name).
    # This means, again, that we can't use the generalised parse-a-detail-line
    # approach as in other parsers.
    class Flog
      # Filters Flog report lines from report lines.
      class DetailLines
        # Internal methods that neither affect nor depend on instance state.
        module Internals
          def self.apply_filter(chunk)
            chunk.delete_if { |item| item.strip.empty? }
          end

          def self.detail_chunk_from(report_lines)
            report_lines.slice_before(/^ +?(\d+\.\d): flog total/).to_a[1]
          end

          def self.details_from(chunk)
            select_lines(apply_filter(chunk))
          end

          def self.select_lines(input)
            input[0..2]
          end
        end
        private_constant :Internals

        def initialize(report_lines)
          @chunk = Internals.detail_chunk_from report_lines
          self
        end

        def lines
          Internals.details_from @chunk
        end
      end # class Rerake::Parser::Flog::DetailLines

      # Parse floating-point score values from Flog output in report
      class Scores
        # Internal methods that neither depend on nor modiify instance state.
        module Internals
          def self._first_part_of_line(line)
            parts = line.split(':')
            return '0.0' if parts.count == 1
            parts.first
          end

          def self.method_from(line)
            line.split[1]
          end

          def self.value_from(line)
            Float(_first_part_of_line line)
          end

          def self.values
            Struct.new(*Scores.names).new
          end
        end
        private_constant :Internals

        def initialize(detail_lines)
          @counts = Internals.values
          @detail_lines = detail_lines
          self
        end

        def self.names
          [:max_name, :max_score, :method_average, :total]
        end

        def to_h
          parse
          @counts.to_h
        end

        private

        def parse
          set_numeric_values
          @counts[:max_name] = Internals.method_from @detail_lines[2]
          self
        end

        def set_numeric_values
          [:total, :method_average, :max_score].each_with_index do |key, index|
            set_value key, index
          end
        end

        def set_value(key, index)
          value = Internals.value_from(@detail_lines[index])
          @counts[key] = value
          self
        end
      end # class Rerake::Parser::Flog::Scores

      ##################### ############################## #####################
      ##################### ### Flog class code below. ### #####################
      ##################### ############################## #####################

      # Internal methods that neither depend on nor affect instance state.
      module Internals
        def self.init_counts
          _clear_values(_init_struct)
        end

        def self._clear_values(values)
          new_values = {}
          values.members.each { |index| new_values[index] = 0 }
          new_values
        end

        def self._init_struct
          Struct.new(*Scores.names).new
        end
      end
      private_constant :Internals

      attr_reader :counts

      def initialize(report_lines)
        @report_lines = report_lines
        @counts = Internals.init_counts
        self
      end

      def parse
        @counts = scores.to_h
        self
      end

      private

      def detail_lines
        DetailLines.new(@report_lines).lines
      end

      def scores
        Scores.new detail_lines
      end
    end # class Rerake::Parser::Flog
  end
end
