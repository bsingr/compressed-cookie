require 'spec_helper'

describe CompressedCookie::Composition do
  it 'should respond #part_of' do
    mock = Object.new
    mock.extend CompressedCookie::Composition
    mock.should respond_to(:parent_cookie)
  end

  it 'should respond #initialize_cookie_part' do
    mock = Object.new
    mock.extend CompressedCookie::Composition
    mock.should respond_to(:initialize_cookie_part)
  end
  
  it 'should respond #parent?' do
    mock = Object.new
    mock.extend CompressedCookie::Composition
    mock.should respond_to(:parent?)
  end
end
