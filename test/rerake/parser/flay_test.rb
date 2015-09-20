
require 'test_helper'

require 'rerake/parser/flay'

describe 'Rerake::Parser::Flay' do
  let(:described_class) { ::Rerake::Parser::Flay }
  let(:obj) { described_class.new input }

  describe 'is initialised to a known state, with zero values for' do
    let(:input) { :whatever_as_long_as_parse_not_called }
    let(:counts) { obj.counts }

    it 'all counts' do
      expect(counts.values.detect(&:nonzero?)).must_be_nil
    end
  end # describe 'is initialised to a known state, with zero values for'

  describe 'has a #parse method that' do
    let(:obj) { described_class.new(input).parse }

    describe 'when given valid Flay input' do
      describe 'which reports no problems' do
        describe 'assigns correct values for' do
          let(:counts) { { total_score: 0 } }

          let(:input) do
            "blah blah blah\n" \
            "we don't care about anything not matching Flay format\n" \
            "Total score (lower is better) = #{counts[:total_score]}\n" \
            "more junk may well appear afterwards\n"
              .split("\n")
          end

          it 'total_score' do
            expect(obj.counts[:total_score]).must_equal counts[:total_score]
          end
        end # describe 'assigns correct values for'
      end # describe 'which reports no problems'

      describe 'which reports detected problems' do
        describe 'assigns correct values for' do
          let(:counts) { { total_score: 38 } }

          let(:input) do
            "blah blah blah\n" \
            "we don't care about anything not matching Flay format\n" \
            "Total score (lower is better) = #{counts[:total_score]}\n" \
            '1) Similar code found in :iter ' \
            "(mass = #{counts[:total_score]})\n" \
            "  path/to/some/file.rb:9\n" \
            "  path/to/some/other_file.rb:7\n" \
            "more junk may well appear afterwards\n"
              .split("\n")
          end

          it 'total_score' do
            expect(obj.counts[:total_score]).must_equal counts[:total_score]
          end
        end # describe 'assigns correct values for'
      end # describe 'which reports detected problems'
    end # describe 'when given valid Flay input'
  end # describe 'has a #parse method that'
end # describe 'Rerake::Parser::Flay'
