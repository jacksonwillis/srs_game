# -*- coding: UTF-8 -*-

require "zlib"
require "base64"
require "readline"

require "bundler/setup"
Bundler.require(:default)

include Term::ANSIColor

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def unblank?
    !blank?
  end

  def to_sentence(options = {})
    words_connector = options[:words_connector] ||  ", "
    two_words_connector = options[:two_words_connector] || " and "
    last_word_connector = options[:last_word_connector] || ", and "

    case length
    when 0
      ""
    when 1
      self[0].to_s.dup
    when 2
      "#{self[0]}#{two_words_connector}#{self[1]}"
    else
      "#{self[0...-1].join(words_connector)}#{last_word_connector}#{self[-1]}"
    end
  end
end

class String
  TRUE_WORDS = %w{t true yes y}
  FALSE_WORDS = %w{f false no n}

  def numeric?
    !!Float(self) rescue false
  end

  def to_bool
    if TRUE_WORDS.include?(downcase) then true
    elsif FALSE_WORDS.include?(downcase) then false end
  end

  def is_boolean?
    !to_bool.nil?
  end

  def args
    strip!

    words.map do |arg|
      arg = arg.to_s
      next if arg.empty?

      if arg.boolean? then arg.to_bool
      elsif arg.numeric? then Float(arg)
      else arg end
    end
  end

  def args?
    !args.empty?
  end

  def words
    scan(/\S+/)
  end
  
  def remove_first_word
    gsub(/^\S+\s*/, "")
  end
end

class Hash
  def +(add)
    temp = {}
    self.each{|k,v| temp[k] = v}
    add.each{|k,v| temp[k] = v}
    temp
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
      greeting_speed = S[:greeting_speed].to_f
      colors = [:red, :yellow, :green, :cyan, :blue, :magenta]

      str.each_line do |line|
        if line =~ /\S/
          print line.__send__(colors[0])
          colors.rotate!
        else
          print line
        end
        sleep (1.0 / greeting_speed)
      end
    end
  end

  include Helpers

  # SRSGame::I is a shortcut for SRSGame::Item
  class Item; end; I = Item # :nodoc:

  class Item # :doc:
    attr_accessor :name

    def initialize(params)
      @name = params[:name] or "Item"
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
    attr_reader *L.directions, :on_enter

    def initialize(params, &block)
      @name = params[:name] || "Room"
      @description = params[:description]
      @items = params[:items].to_a or []
      @block = block # @block is called on initialization
      @on_enter, @on_leave = nil

      @block.call(self) if block
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

    def on_enter(&b)
      @on_enter = b
    end

    def on_leave(&b)
      @on_leave = b
    end

    def enter
      @on_enter.call(self) if @on_enter
    end

    def leave
      @on_leave.call(self) if @on_leave
    end

    def info
      o = "You find yourself in #{@name}. "
      o << "#{@description}. " if @description
      o << "\nItems here are #{items.to_sentence}." if @items.unblank?
      o << "\nExits are to the #{exits.to_sentence}." if exits.unblank?
      o
    end

    def to_s
      "#<SRSGame::Location #{@name.inspect} @items=#{@items.inspect} exits=#{exits.inspect}>"
    end
  end

  # SRSGame::S is a shortcut for SRSGame::Settings
  class Settings; end; S = Settings # :nodoc:

  class Settings # :doc:
    class << self
      attr_reader :env

      def seed(seed)
        @env ||= default_settings
        # Add what we are seeding to @env
        @env += seed
      end

      # S[:foo] is the same as S.env["FOO"]
      def [](key)
        @env[key.to_s.upcase]
      end

      def default_settings
        {
          "GREETING_SPEED" => 20,
          "SAYS_HOWDY_PARTNER" => false
        }
      end
    end
  end

  class Commands
    def method_missing(m, a)
      puts "#{self.class}##{m}: not found".red
    end

    L.directions.each do |dir|
      define_method("_#{dir}") do |args|
        p $room.exits
        if $room.exits.include?(dir)
          $room = $room.__send__(dir)
        else
          puts "NOPE. Can't go that way."
        end
      end
    end
  end

  class << self
    def play(middleware, env = {})
      raise "No middleware for SRSGame.play" unless middleware
      extend middleware

      Settings.seed(env)

      $room = main_room
      command = middleware.const_get(:Commands).new

      rainbow_say(greeting)

      puts "Howdy, partner!" if S[:says_howdy_partner].to_s.to_bool

      loop do
        $room.enter
        puts $room.info
        
        input = Readline.readline("$ ", true)
        input.gsub!(/\$\((.*)\)/) { send(self, $1.to_s) }

        unless input.blank?
          method = input.words.first
          argument_string = input.remove_first_word

          command.__send__("_#{method}", argument_string)
        end
      end
    end
  end
end
