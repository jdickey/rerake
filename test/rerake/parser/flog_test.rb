
require 'test_helper'

require 'rerake/parser/flog'

describe 'Rerake::Parser::Flog' do
  let(:described_class) { ::Rerake::Parser::Flog }
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

    describe 'when given valid Flog input' do
      describe 'assigns correct values for' do
        let(:counts) do
          {
            total: 160.1,
            method_average: 4.6,
            max_score: 8.6,
            max_name: 'Foo::Bar::Baz#values'
          }
        end

        let(:input) do
          "blah blah blah\n" \
          "we don't care about anything not matching Flog format\n" \
          "Total score (lower is better) = 0\n" \
          "   160.1: flog total\n" \
          "     4.6: flog/method average\n\n" \
          "     8.6: Foo::Bar::Baz#values lib/foo/bar/baz.rb:58\n" \
          "     7.9: Foo::Bar::Quux#matcher lib/foo/bar/quux.rb:35\n" \
          "     6.7: Foo::Bar::Quux#detail_line lib/foo/bar/quux.rb:42\n" \
          "more junk may well appear afterwards\n"
            .split("\n")
        end

        it 'counts' do
          expect(obj.counts.to_h).must_equal counts
        end
      end # describe 'assigns correct values for'
    end # describe 'when given valid Flog input'
  end # describe 'has a #parse method that'
end # describe 'Rerake::Parser::Flog'
