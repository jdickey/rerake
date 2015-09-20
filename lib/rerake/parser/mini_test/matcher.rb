
module Rerake
  module Parser
    # Parses MiniTest (Spec/Unit) output, storing reported count values.
    class MiniTest
      # Builds regexp matcher and index keys for MiniTest parser.
      class Matcher
        # Internal methods that neither affect nor depend on instance state.
        module Internals
          def self.indexes
            _detail_line_part_strings.map(&:to_sym)
          end

          def self.pattern_str
            _parts.join(', ')
          end

          def self._detail_line_part_strings
            ['tests', 'assertions', 'failures', 'errors', 'skips']
          end

          def self._parts
            _detail_line_part_strings.map { |what| '(\d+) ' + what }
          end
        end

        def initialize
          self
        end

        # This method smells of :reek:UtilityFunction
        def to_regexp
          Regexp.new(Internals.pattern_str)
        end

        def self.indexes
          Internals.indexes
        end
      end # class Rerake::Parser::MiniTest::Matcher
    end # class Rerake::Parser::MiniTest
  end
end
