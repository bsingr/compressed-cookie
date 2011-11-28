class CompressedCookie
  module BlockAccessors
    # WRITE
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
    # READ
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
