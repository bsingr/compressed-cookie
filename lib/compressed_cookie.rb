require File.join(File.dirname(__FILE__), "compressed_cookie", "version")

class CompressedCookie
  class UndefinedCompressorKeyError < ArgumentError; end
  
  ### IMPARATIVE DECLARATIONS ###
  def self.compressor_keys(hash = nil)
    @compressor_keys ||= {}
    @compressor_keys.merge!(hash) if hash
    @compressor_keys
  end
  def self.part_of(clazz, key)
    @parent_cookie_class = clazz
    @parent_cookie_key = key
  end
  
  ### CONSTRUCTOR ###
  # default
  # @param [ #[], #[]= ] cookie object (external) itself
  def initialize(cookie, write_access = false)
    @cookie = self.class.initialize_cookie_part(cookie)
    self.extend readers
    self.extend writers if write_access
  end
  # WRITE
  def self.write(cookie, &block)
    writer = self.new(cookie, true)
    # return the block's return value
    if block_given?
      yield writer
    # return the writer itself
    else
      writer
    end
  end
  # READ
  def self.read(cookie, &block)
    reader = self.new(cookie)
    # return the block's return value
    if block_given?
      yield reader
    # return the reader itself
    else
      reader
    end
  end
  
  ### BULK OPERATIONS ###
  # READ
  def to_hash
    self.class.compressor_keys.inject({}) do |result, pair|
      name, key = pair
      result[name] = self.send(name)
      result
    end
  end
  # WRITE
  def update!(hash)
    hash.each do |key, value|
      method_name = "#{key}="
      self.send(method_name, value) if self.respond_to?(method_name)
    end
  end
  
  def self.initialize_cookie_part(_cookie)
    cookie = _cookie
    if parent?
      cookie = @parent_cookie_class.write(cookie) do |writer|
        # extract the cookie part from the parent
        if existing_cookie_part = writer.send("#{@parent_cookie_key}")
          existing_cookie_part
        # if the cookie part is empty => then create it as an empty array
        else
          new_cookie_part = writer.send("#{@parent_cookie_key}=", Array.new)
          new_cookie_part
        end
      end
    end
    cookie
  end
  
  def self.parent?
    if defined?(@parent_cookie_class) && defined?(@parent_cookie_key)
      true
    else
      false
    end
  end
  
  def self.key(name)
    if compressor_keys.has_key? name
      compressor_keys[name]
    else
      raise UndefinedCompressorKeyError.new "#{self.class} has no compressor key=#{name}"
    end
  end
  
private
  
  def readers
    keys = self.class.compressor_keys
    Module.new do
      keys.each_pair do |method_name, key|
        define_method method_name do
          @cookie[key]
        end
      end
    end
  end
  def writers
    keys = self.class.compressor_keys
    Module.new do
      keys.each_pair do |method_name, key|
        define_method "#{method_name}=" do |value|
          @cookie[key] = value
        end
      end
    end
  end
end
