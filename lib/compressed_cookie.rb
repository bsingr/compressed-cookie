require File.join(File.dirname(__FILE__), "compressed_cookie", "version")
require File.join(File.dirname(__FILE__), "compressed_cookie", "composition")
require File.join(File.dirname(__FILE__), "compressed_cookie", "block_accessors")
require File.join(File.dirname(__FILE__), "compressed_cookie", "bulk_accessors")

class CompressedCookie
  class UndefinedCompressorKeyError < ArgumentError; end
  extend CompressedCookie::Composition
  extend CompressedCookie::BlockAccessors
  include CompressedCookie::BulkAccessors
  
  # the index used for storing/retrieving values in a cookie
  # @param [Hash] partial cookie index that will be merged in (optional)
  # @return [Hash] cookie index
  def self.cookie_index(hash = nil)
    @cookie_index ||= {}
    @cookie_index.merge!(hash) if hash
    @cookie_index
  end
  
  # @param [ #[], #[]= ] cookie object (external) itself
  # @param [ TrueClass, FalseClass ] true, when write access is required 
  def initialize(cookie, write_access = false)
    @cookie = self.class.initialize_cookie_part(cookie)
    self.extend readers
    self.extend writers if write_access
  end
  
  # @param [Symbol] attribute name
  # @return [Fixnum] attribute index
  def self.key(name)
    if cookie_index.has_key? name
      cookie_index[name]
    else
      raise UndefinedCompressorKeyError.new "#{self.class} has no compressor key=#{name}"
    end
  end
  
private
  
  # creates a module that provides attribute readers
  # @return [Module] readers 
  def readers
    keys = self.class.cookie_index
    Module.new do
      keys.each_pair do |method_name, key|
        define_method method_name do
          @cookie[key]
        end
      end
    end
  end
  
  # creates a module that provides attribute writers
  # @return [Module] writers
  def writers
    keys = self.class.cookie_index
    Module.new do
      keys.each_pair do |method_name, key|
        define_method "#{method_name}=" do |value|
          @cookie[key] = value
        end
      end
    end
  end
end
