require 'spec_helper'

describe CompressedCookie::BulkAccessors do
  it 'should respond #to_hash' do
    mock = Object.new
    mock.extend CompressedCookie::BulkAccessors
    mock.should respond_to(:to_hash)
  end
  
  it 'should respond #update!' do
    mock = Object.new
    mock.extend CompressedCookie::BulkAccessors
    mock.should respond_to(:update_attributes)
  end
end
