class CompressedCookie
  module BlockAccessors
    # provides a CompressedCookie with read + write access
    # @param [#[], #[]=] external cookie object
    # @param [Proc] optional block (will receive the cookie accessor)
    # @return [CompressedCookie, Object] when no block is 
    def write(cookie, &block)
      writer = self.new(cookie, true)
      # return the block's return value
      if block_given?
        yield writer
      # return the writer itself
      else
        writer
      end
    end
    
    # provides a CompressedCookie with read access
    # @param [#[]] external cookie object
    # @param [Proc] optional block (will receive the cookie accessor)
    # @return [CompressedCookie, Object] when no block is
    def read(cookie, &block)
      reader = self.new(cookie)
      # return the block's return value
      if block_given?
        yield reader
      # return the reader itself
      else
        reader
      end
    end
  end
end
