require "zlib"
require "base64"
require "readline"
require "bundler/setup"
Bundler.require(:default)
include Term::ANSIColor

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
          print line.__send__(colors[0])
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

      rainbow_say(greeting)
      room = main_room

      loop do
        p room
        room.enter
        room = room.__send__(Readline.readline("$ ", true))
      end
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
    
    attr_accessor :name, :description, :items, :block
    attr_reader *L.directions

    def initialize(params, &block)
      @name = params[:name].to_s
      @description = params[:description].to_s
      @items = params[:items].to_a or []
      @block = block
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
      L.directions.select { |dir| __send__(dir) }
    end

    def enter
      block.call if block
    end

    def to_s
      "#<SRSGame::Location #{@name.inspect} @items=#{@items.inspect} exits=#{exits.inspect}>"
    end
  end
end
