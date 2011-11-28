# CompressedCookie

This gem provides a wrapper around key-based cookie accessors.

## Installation

    gem install compressed_cookie

## Examples

    # define your cookie class
    class MyCookie < CompressedCookie
      cookie_index :foo => 0,
                   :bar => 1
    end
    
    # use it to write to a raw cookie object
    raw_cookie = []
    MyCookie.write(raw_cookie) do |writer|
      writer.foo = 'hello world'
    end
    puts raw_cookie
    # => ['hello world', nil]
    
    # use it to read from a raw cookie object
    MyCookie.read(raw_cookie) do |reader|
      puts reader.foo
      # => 'hello world'
    end

## Development

    `bundle install`

    `bundle exec rspec spec`

# License

Copyright 2011 Jens Bissinger. All rights reserved. [MIT-LICENSE](MIT-LICENSE)