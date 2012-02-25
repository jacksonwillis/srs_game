# -*- coding: UTF-8 -*-

require "zlib"
require "base64"
require "readline"

require "bundler/setup"
Bundler.require(:default)

include Term::ANSIColor

class Object
  # Returns true if false, nil, or self.empty?
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end # blank?

  # Opposite of Object#blank?
  def unblank?
    !self.blank?
  end # def unblank?

  # Removes "_" from beginning of line
  def command_pp
    to_s.gsub(/^_/, "")
  end # def command_pp

  # From ActiveSupport[http://api.rubyonrails.org/classes/Array.html#method-i-to_sentence].
  # Converts the array to a comma-separated sentence where the last element is joined by the connector word. Options:
  # * :words_connector:: - The sign or word used to join the elements in arrays with two or more elements (default: ", ")
  # * :two_words_connector:: - The sign or word used to join the elements in arrays with two elements (default: " and ")
  # * :last_word_connector:: - The sign or word used to join the last element in arrays with three or more elements (default: ", and ")
  # * :bold:: - Bolds the elements being joined. (default: false)

  def to_sentence(options = {})
    words_connector = options[:words_connector] ||  ", "
    two_words_connector = options[:two_words_connector] || " and "
    last_word_connector = options[:last_word_connector] || ", and "

    if options[:bold]
      return to_sentence Array[self] unless respond_to? :map!
      map!(&:to_s)
      map!(&:bold)
    end # if

    case length
    when 0
      ""
    when 1
      self[0].to_s.dup
    when 2
      "#{self[0]}#{two_words_connector}#{self[1]}"
    else
      "#{self[0...-1].join(words_connector)}#{last_word_connector}#{self[-1]}"
    end # case
  end # def to_sentence
end # class Object

class String
  TRUE_WORDS = %w{t true yes y}
  FALSE_WORDS = %w{f false no n}

  # Does the string represent a numeral in Ruby?
  def numeric?
    !!Float(self) rescue false
  end # def numeric?

  # Convert to boolean value
  def to_bool
    if TRUE_WORDS.include?(downcase) then true
    elsif FALSE_WORDS.include?(downcase) then false end # if
  end

  # Can the string be converted to a boolean value?
  def boolean?
    !to_bool.nil?
  end # def is_boolean?

  # Turn the string in to an array of arguments.
  # It tries to convert words into booleans and floats. Example:
  #     "3.14 yes gaga false".args #=> [3.14, true, "gaga", false]
  def args
    strip!

    words.map do |arg|
      arg = arg.to_s
      next if arg.empty?

      if arg.boolean? then arg.to_bool
      elsif arg.numeric? then Float(arg)
      else arg end # if
    end # map
  end # def args

  def args?
    !args.empty?
  end # def args

  # Scans the string for groups of non-whitespace characters.
  def words
    scan(/\S+/)
  end # def words
  
  # Removes the first group of non-whitespace characters.
  def remove_first_word
    gsub(/^\S+\s*/, "")
  end # def remove_first_word
end # class String

class Hash
  # Add two hashes. Does not overwrite pre-existing values.
  def +(add)
    temp = {}
    add.each { |k, v| temp[k] = v}
    self.each { |k, v| temp[k] = v}
    temp
  end # def +

  # Add two hashes. Overwrites pre-existing values, and is destructive.
  def <<(add)
    temp = {}
    self.each { |k, v| temp[k] = v}
    add.each { |k,v| temp[k] = v}
    replace temp
  end # def <<
end # class Hash

module SRSGame
  module Helpers
    # Compress and base64 encode a string
    def base64_zlib_deflate(s)
      Base64.encode64(Zlib::Deflate.deflate(s, Zlib::BEST_COMPRESSION))
    end # def base64_zlib_deflate

    # Base64 decode and decompress and a string
    def base64_zlib_inflate(s)
      Zlib::Inflate.inflate(Base64.decode64(s))
    end # def base64_zlib_inflate

    # Output a string, colorfully.
    def rainbow_say(str)
      greeting_speed = S[:greeting_speed].to_f
      colors = [:red, :yellow, :green, :cyan, :blue, :magenta]

      str.each_line do |line|
        if line =~ /\S/
          print line.__send__(colors[0])
          colors.rotate!
        else
          print line
        end # if
        sleep 1.0 / greeting_speed
      end # each_line
    end # def rainbow_say
  end # module Helpers

  include Helpers

  # SRSGame::I is a shortcut for SRSGame::Item
  class Item; end; I = Item # :nodoc:

  class Item # :doc:
    attr_accessor :name

    # params:
    # :name:: Displayed when the item is regarded. (default: "Item")
    def initialize(params)
      @name = params[:name] or "Item"
    end # def initialize

    # Name of the item
    def to_s
      @name
    end # def to_s
  end # class Item

  # SRSGame::L is a shortcut for SRSGame::Location
  class Location; end; L = Location # :nodoc:

  class Location # :doc:
    class << self
      def direction_relationships
        [["north", "south"], ["east", "west"], ["up", "down"]]
      end # def direction_relationships

      def mirrored_directions
        direction_relationships + direction_relationships.map { |a| a.reverse }
      end # def mirrored_directions

      # All directions available
      def directions
        direction_relationships.flatten
      end # def directions
    end # class << self
    
    attr_accessor :name, :description, :items, :block
    attr_reader(*L.directions, :on_enter)

    # params:
    # * :name:: Title of the room (default: "a room")
    # * :description:: Displayed when the name is regarded.
    # * :items:: Items available in the room. Stored in @items.
    # * :on_enter:: Block called every time room is entered.
    #
    # &block:: called on initialization
    def initialize(params, &block)
      @name = params[:name] || "a room"
      @description = params[:description].to_s
      @items = params[:items].to_a or []
      @block = block # @block is called on initialization
      @on_enter, @on_leave = nil

      @block.call(self) if block
    end # def initialize

    # We have to create our own setter methods to do the mirrored direction relationships
    L.mirrored_directions.each do |dir|
      direction, opposite = *dir
      define_method(direction + "=") do |loc|
        # set @direction to loc
        instance_variable_set "@" + direction, loc
        # _direction is @direction
        _direction = instance_variable_get("@" + direction)
        _direction.__send__(opposite + "=", self) unless _direction.__send__(opposite)
      end # define_method
    end # each

    # Available directions (where __send__(dir) is truthy)
    def exits
      L.directions.select { |dir| __send__(dir) }
    end # def exits

    # Set @on_enter to &b
    def on_enter(&b)
      @on_enter = b
    end # def on_enter

    # Set @on_leave to &b
    def on_leave(&b)
      @on_leave = b
    end # def on_leave

    # Call @on_enter
    def enter
      @on_enter.call(self) if @on_enter
    end # def enter

    # Call @on_leave
    def leave
      @on_leave.call(self) if @on_leave
    end # def leave

    # Information displayed when a room is entered.
    def info
      o = "You find yourself in #{@name}. "
      o << "#{@description}. " if @description
      o << "\nItems here are #{@items.map(&:to_s).to_sentence(:bold => true)}." if @items.unblank?
      o << "\nExits are to the #{exits.to_sentence(:bold => true)}." if exits.unblank?
      o
    end # def info

    def to_s
      "#<SRSGame::Location #{@name.inspect} @items=#{@items.inspect} exits=#{exits.inspect}>"
    end # def to_s
  end # class Location

  # SRSGame::S is a shortcut for SRSGame::Settings
  class Settings; end; S = Settings # :nodoc:

  class Settings # :doc:
    class << self
      attr_reader :env

      # Add what we are seeding to @env
      def seed(seed)
        @env ||= default_settings
        @env << seed
      end # def seed

      # S[:foo] is the same as S.env["FOO"]
      def [](key)
        @env[key.to_s.upcase]
      end # def []

      def default_settings
        {
          "GREETING_SPEED" => 20,
          "SAYS_HOWDY_PARTNER" => false,
          "MATCHES_SHORT_METHODS" => true
        }
      end # def default_settings
    end # class << self
  end # class Settings

  class Commands
    def method_missing(m, a)
      puts "#{self.class}##{m}: not found".red
    end # def method_missing

    L.directions.each do |dir|
      define_method("_#{dir}") do |args|
        if $room.exits.include?(dir)
          $room = $room.__send__(dir)
        else
          puts "NOPE. Can't go that way."
        end # if
      end # define_method
    end # each

    def callable_methods
      methods.grep(/^_\w+[^_]$/)
    end # def callable_methods

    # From GoRuby[link:https://github.com/ruby/ruby/blob/trunk/golf_prelude.rb]
    def matching_methods(s='', m=callable_methods)
      # build a regex which starts with ^ (beginning)
      # take every letter of the method_name
      #   insert "(.*?)" instead, which means: match anything and take the smallest match
      #   and insert the letter itself (but escape regex chars)
      #
      # for example s='matz'
      # => /^(.*?)m(.*?)a(.*?)t(.*?)z/
      #
      r=/^#{s.to_s.gsub(/./){"(.*?)"+Regexp.escape($&)}}/

      # match all available methods for this regex
      #  and sort them by the least matches of the "fill" regex groups
      m.grep(r).sort_by do |i|
        i.to_s.match(r).captures.map(&:size) << i
      end # sort_by
    end # def matching_methods
  end # class Commands

  class << self
    # Main loop
    def play(middleware, env = {})
      raise "No middleware for SRSGame.play" unless middleware
      extend middleware

      Settings.seed(env)

      $room = main_room
      command = middleware.const_get(:Commands).new

      rainbow_say(greeting + "\n")

      puts "Howdy, partner!" if S[:says_howdy_partner].to_s.to_bool

      loop do
        puts $room.info
        $room.enter
        
        input = Readline.readline("$ ", true)

        unless input.blank?
          method = input.words.first
          argument_string = input.remove_first_word

          if S[:matches_short_methods].to_s.to_bool
            matches = command.matching_methods(method)
            parsed_method = matches.first

            if matches.length > 1
              puts "#{method} matches multiple methods: #{matches.map(&:command_pp)}".magenta
            end # if

            if method != parsed_method
              puts "#{method} ~> #{parsed_method.command_pp}".magenta
            end # if
          end # if

          command.__send__(parsed_method, argument_string)
        end # unless
      end # loop
    end # def play
  end # class << self
end # module SRSGame
