require 'spec_helper'

describe CompressedCookie::BlockAccessors do
  it 'should respond #write' do
    mock = Object.new
    mock.extend CompressedCookie::BlockAccessors
    mock.should respond_to(:write)
  end
  
  it 'should respond #read' do
    mock = Object.new
    mock.extend CompressedCookie::BlockAccessors
    mock.should respond_to(:read)
  end
end
