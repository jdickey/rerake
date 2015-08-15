
require 'test_helper'

require 'rerake/parser/reek'

describe 'Rerake::Parser::Reek' do
  let(:described_class) { ::Rerake::Parser::Reek }
  let(:obj) { described_class.new input }

  describe 'is initialised to a known state, with zero values for' do
    let(:input) { :whatever_as_long_as_parse_not_called }
    let(:counts) { obj.counts }

    it 'all counts' do
      expect(counts.to_h.values.detect(&:nonzero?)).must_be_nil
    end
  end # describe 'is initialised to a known state, with zero values for'

  describe 'has a #parse method that' do
    let(:obj) { described_class.new(input).parse }

    describe 'when given valid Reek input' do
      describe 'when no warnings are generated' do
        describe 'assigns correct values for' do
          let(:counts) { { warnings: 0 } }
          let(:input) do
            "blah blah blah\n" \
            "we don't care about anything not matching Reek format\n" \
            "0 total warnings\n" \
            "more junk may well appear afterwards\n"
              .split("\n")
          end

          it 'counts' do
            expect(obj.counts.to_h).must_equal counts
          end
        end # describe 'assigns correct values for'
      end # describe 'when no warnings are generated'

      describe 'when warnings are generated' do
        describe 'assigns correct values to' do
          let(:counts) { { warnings: 1 } }
          let(:input) do
            "blah blah blah\n" \
            "we don't care about anything not matching Reek format\n" \
            "app/foo/bar.rb -- 1 warning:\n" \
            "  app/foo/bar.rb:22: Foo::Bar#initialize doesn't depend on" \
            " instance state (UtilityFunction)\n" \
            "1 total warning\n" \
            "more junk may well appear afterwards\n"
              .split("\n")
          end

          it 'counts' do
            expect(obj.counts.to_h).must_equal counts
          end
        end # describe 'assigns correct values to'
      end # describe 'when warnings are generated'
    end # describe 'when given valid Reek input'
  end # describe 'has a #parse method that'
end # describe 'Rerake::Parser::Reek'
