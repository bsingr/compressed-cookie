require File.join(File.dirname(__FILE__), "compressed_cookie", "version")
require File.join(File.dirname(__FILE__), "compressed_cookie", "composition")
require File.join(File.dirname(__FILE__), "compressed_cookie", "block_accessors")
require File.join(File.dirname(__FILE__), "compressed_cookie", "bulk_accessors")

class CompressedCookie
  class UndefinedCompressorKeyError < ArgumentError; end
  extend CompressedCookie::Composition
  extend CompressedCookie::BlockAccessors
  include CompressedCookie::BulkAccessors
  
  ### IMPARATIVE DECLARATIONS ###
  def self.cookie_index(hash = nil)
    @cookie_index ||= {}
    @cookie_index.merge!(hash) if hash
    @cookie_index
  end
  
  ### CONSTRUCTOR ###
  # default
  # @param [ #[], #[]= ] cookie object (external) itself
  def initialize(cookie, write_access = false)
    @cookie = self.class.initialize_cookie_part(cookie)
    self.extend readers
    self.extend writers if write_access
  end
  
  def self.key(name)
    if cookie_index.has_key? name
      cookie_index[name]
    else
      raise UndefinedCompressorKeyError.new "#{self.class} has no compressor key=#{name}"
    end
  end
  
private
  
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
