
require 'test_helper'

describe 'Rerake.call' do
  let(:cmd) { Rerake.call }

  before do
    ENV['RERAKE_COMMAND'] = 'find lib -name \*.rb'
  end

  it 'returns a Rerake::CommandOutput instance' do
    expect(cmd).must_be_instance_of Rerake::CommandOutput
  end

  describe 'returns a Rerake::CommandOutput instance with' do
    it 'a status code of 0' do
      expect(cmd.status).must_equal 0
    end

    it 'no errors indicated' do
      expect(cmd.errors).must_be_empty
    end

    it 'expected output' do
      expected = Dir.glob('lib/**/*.rb')
      expect(cmd.output).must_equal expected
    end
  end # describe 'returns a Rerake::CommandOutput instance with'
end

describe 'Rerake::VERSION' do
  it 'exists' do
    expect(::Rerake::VERSION).wont_be_nil
  end
end
