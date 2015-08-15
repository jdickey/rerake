
require 'test_helper'

require 'rerake/parser/mini_test/counts'

describe 'Rerake::Parser::MiniTest::Counts' do
  let(:described_class) { Rerake::Parser::MiniTest::Counts }
  let(:obj) { described_class.new keys }
  let(:keys) { [:foo, :bar, :baz] }

  it 'can be initialised from an array of symbols' do
    expect { described_class.new([:foo, :bar, :baz]) }.must_be_silent
  end

  describe 'has an #assign_from method that' do
    it 'assigns to the members as defined, in order' do
      obj = described_class.new([:foo, :bar, :baz])
      obj.assign_from %w(1 4 2)
      expect(obj[:foo]).must_equal 1
      expect(obj[:bar]).must_equal 4
      expect(obj[:baz]).must_equal 2
    end
  end # describe 'has an #assign_from method that'

  it 'has a #to_s method that renders as it would a Hash' do
    hash = obj.to_hash
    expect(obj.to_s).must_equal hash.to_s
  end
end # describe 'Rerake::Parser::MiniTest::Counts'
