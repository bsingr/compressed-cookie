class CompressedCookie
  module BulkAccessors    
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
  end
end
