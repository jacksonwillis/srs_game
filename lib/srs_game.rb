require "zlib"
require "base64"

class String
  SRS_ANSI_COLORS = {
          clear: 0 ,
          reset: 0 ,
           bold: 1 ,
           dark: 2 ,
         italic: 3 ,
      underline: 4 ,
     underscore: 4 ,
          blink: 5 ,
    rapid_blink: 6 ,
       negative: 7 ,
      concealed: 8 ,
  strikethrough: 9 ,
          black: 30,
            red: 31,
          green: 32,
         yellow: 33,
           blue: 34,
        magenta: 35,
           cyan: 36,
          white: 37,
       on_black: 40,
         on_red: 41,
       on_green: 42,
      on_yellow: 43,
        on_blue: 44,
     on_magenta: 45,
        on_cyan: 46,
       on_white: 47,
  }

  def ansi(code)
    "\e[#{SRS_ANSI_COLORS[code]}m#{self}\e[0m"
  end
end

module SRSGame
  module Helpers
    def base64_zlib_deflate(s)
      Base64.encode64(Zlib::Deflate.deflate(s))
    end

    def base64_zlib_inflate(s)
      Zlib::Inflate.inflate(Base64.decode64(s))
    end

    def rainbow_say(str)
      colors = [:red, :yellow, :green, :cyan, :blue, :magenta]
      str.each_line do |line|
        if line =~ /\S/
          print line.ansi(colors[0])
          colors.rotate!
        else
          print line
        end
        sleep 0.05
      end
    end
  end

  include Helpers

  class << self
    def play(middleware, env)
      raise "No middleware for SRSGame.play" unless middleware
      extend middleware
      rainbow_say greeting
      p main_room, main_room.east
    end
  end

  # SRSGame::L is a shortcut for SRSGame::Location
  class Location; end; L = Location # :nodoc:

  class Location # :doc:
    class << self
      def direction_relationships
        [["north", "south"], ["east", "west"], ["up", "down"]]
      end

      def mirrored_directions
        direction_relationships + direction_relationships.map { |a| a.reverse }
      end

      def directions
        direction_relationships.flatten
      end
    end
    
    attr_accessor :name, :description, :items
    attr_reader *L.directions

    def initialize(params)
      @name = params[:name]
      @description = params[:description]
      @items = []
    end

    # We have to create our own setter methods to do the mirrored direction relationships
    L.mirrored_directions.each do |dir|
      direction, opposite = *dir
      # Old code:
      #     eval <<-EOS
      #       def #{direction}=(loc)
      #         @#{direction} = loc
      #         @#{direction}.#{opposite} = self unless @#{direction}.#{opposite}
      #       end
      #     EOS
      define_method(direction + "=") do |loc|
        # set @direction to loc
        instance_variable_set "@" + direction, loc
        # _direction is @direction
        _direction = instance_variable_get("@" + direction)
        _direction.__send__(opposite + "=", self) unless _direction.__send__(opposite)
      end
    end

    def exits
      # Directions where __send__(dir) is truthy
      L.directions.flatten.select { |dir| __send__(dir) }
    end

    def to_s
      "#<SRSGame::Location #{@name.inspect} @items=#{@items.inspect} exits=#{exits.inspect}>"
    end
  end
end
