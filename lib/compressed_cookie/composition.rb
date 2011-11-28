class CompressedCookie
  module Composition
    def part_of(clazz, key)
      @parent_cookie_class = clazz
      @parent_cookie_key = key
    end
    
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
    
    def parent?
      if defined?(@parent_cookie_class) && defined?(@parent_cookie_key)
        true
      else
        false
      end
    end
  end
end
