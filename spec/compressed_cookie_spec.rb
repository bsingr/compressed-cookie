require 'spec_helper'

describe 'CompressedCookie' do
  
  describe 'class declaration api' do
    it 'should respond to #compressor_keys' do
      CompressedCookie.should respond_to(:compressor_keys)
    end
    it 'should respond to #part_of' do
      CompressedCookie.should respond_to(:part_of)
    end
  end
  
  describe 'simple cookie' do
    class SimpleCookieMock < CompressedCookie
      compressor_keys :zero => 0,
                      :one => 1,
                      :two => 2
    end
    before :each do
      @cookie_mock = [
        'foo', # zero
        'bar'  # one
               # two is nil
      ]
    end
    
    describe 'class methods' do
      it 'should lookup keys' do
        SimpleCookieMock.key(:zero).should == 0
        SimpleCookieMock.key(:one).should == 1
        SimpleCookieMock.key(:two).should == 2
      end
      it 'should raise UndefinedCompressorKeyError if lookup key is undefined' do
        lambda do
          SimpleCookieMock.key(:three)
        end.should raise_error(CompressedCookie::UndefinedCompressorKeyError)
      end
    end
    
    describe 'read-only instance' do
      before :each do
        @mock = SimpleCookieMock.new(@cookie_mock)
      end
      it 'should respond only to read methods' do
        @mock.should respond_to(:one)
        @mock.should respond_to(:two)
        @mock.should_not respond_to('one=')
        @mock.should_not respond_to('two=')
      end
      it 'should read single cookies value' do
        @mock.one.should == 'bar'
        @mock.two.should == nil
      end
      it 'should read multiple values via #to_hash' do
        @mock.to_hash.should == {:zero => 'foo', :one => 'bar', :two => nil}
      end
    end
    
    describe 'read/write instance' do
      before :each do
        @mock = SimpleCookieMock.new(@cookie_mock, true)
      end
      it 'should respond to read + write methods' do
        @mock.should respond_to(:one)
        @mock.should respond_to(:two)
        @mock.should respond_to('one=')
        @mock.should respond_to('two=')
      end
      it 'should write new cookies value' do
        @mock.two = 'new-baz'
        @mock.two.should == 'new-baz'
        @cookie_mock.should == ['foo', 'bar', 'new-baz']
      end
      it 'should overwrite existing cookies value' do
        @mock.one = 'new-bar'
        @mock.one.should == 'new-bar'
        @cookie_mock.should == ['foo', 'new-bar']
      end
      it 'should write multiple values via #update!' do
        @mock.update!(:zero => 'new-foo', :one => 'new-bar', :two => 'new-baz')
        @cookie_mock.should == ['new-foo', 'new-bar', 'new-baz']
      end
    end
  end
  
  describe 'nested cookie' do
    class RootCookieMock < CompressedCookie
      compressor_keys :zero => 0,
                      :child => 1
    end
    class ChildCookieMock < CompressedCookie
      part_of RootCookieMock, :child
      compressor_keys :zero => 0,
                      :one  => 1
    end
    before :each do
      @cookie_mock = [:foo, [:bar, :baz]]
    end
    describe "root" do
      before :each do
        @mock = RootCookieMock.new(@cookie_mock, true)
      end
      it 'should read the childs values at one' do
        @mock.child.should == [:bar, :baz]
      end
      it 'should tell that it has NO parent' do
        RootCookieMock.parent?.should == false
      end
    end
    describe "child" do
      before :each do
        @mock = ChildCookieMock.new(@cookie_mock, true)
      end
      it 'should read its cookie values' do
        @mock.zero.should == :bar
        @mock.one.should == :baz
      end
      it 'should write its cookie values' do
        @mock.zero = :written_foo
        @mock.zero.should == :written_foo
        @cookie_mock.should == [:foo, [:written_foo, :baz]]
      end
      it 'should tell that it has a parent' do
        ChildCookieMock.parent?.should == true
      end
    end
  end
end
