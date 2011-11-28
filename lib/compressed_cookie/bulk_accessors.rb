class CompressedCookie
  module BulkAccessors
    # exports all values into a hash 
    # @return [Hash] hash
    def to_hash
      self.class.cookie_index.inject({}) do |result, pair|
        name, key = pair
        result[name] = self.send(name)
        result
      end
    end
    
    # updates all values via hash by using setter methods
    # @param [Hash] hash
    def update_attributes(hash)
      hash.each do |key, value|
        method_name = "#{key}="
        self.send(method_name, value) if self.respond_to?(method_name)
      end
    end
  end
end
