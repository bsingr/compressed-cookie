class CompressedCookie
  module Composition
    # @param [Class] parent cookie model
    # @param [Symbol] key where the current child cookie model is mapped to
    def parent_cookie(clazz, key)
      @parent_cookie_class = clazz
      @parent_cookie_key = key
    end
    
    # @param [#[], #[]=] raw cookie
    def initialize_cookie_part(_cookie)
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
    
    # is it a child or a parent cookie model
    # @return [TrueClass, FalseClass] true, when it's a parent
    def parent?
      if defined?(@parent_cookie_class) && defined?(@parent_cookie_key)
        true
      else
        false
      end
    end
  end
end
