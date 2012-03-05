#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

require "zlib"
require "base64"
require "readline"
require "term/ansicolor"

include Term::ANSIColor

# Methods for every object
class Object
  # Words that become true when to_bool is called
  TRUE_WORDS = %w{t true yes y}
  # Words that become false when to_bool is called
  FALSE_WORDS = %w{f false no n}

  # Returns true if false, nil, or self.empty?
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end # blank?

  # Opposite of Object#blank?
  def unblank?
    !self.blank?
  end # def unblank?

  # Convert to boolean value
  def to_bool
    dc = to_s.downcase
    if TRUE_WORDS.include?(dc) then true
    elsif FALSE_WORDS.include?(dc) then false end # if
  end # def to_bool

  # Can the string be converted to a boolean value?
  def boolean?
    !to_bool.nil?
  end # def is_boolean?

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
  # Does the string represent a numeral in Ruby?
  def numeric?
    !!Float(self) rescue false
  end # def numeric?

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

# The main SRS GAME namespace
module SRSGame
  # Helpful methods that are included throught out the project
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

  # From Dwemthy's Array by _why the lucky stiff
  # http://mislav.uniqpath.com/poignant-guide/dwemthy/
  class Traitable
    # Get a metaclass for this class
    def self.metaclass; class << self; self; end; end

    # Advanced metaprogramming code for nice, clean traits
    def self.traits( *arr )
      return @traits if arr.empty?

      # 1. Set up accessors for each variable
      attr_accessor *arr

      # 2. Add a new class method to for each trait.
      arr.each do |a|
        metaclass.instance_eval do
          define_method( a ) do |val|
            @traits ||= {}
            @traits[a] = val
          end # define_method
        end # instance_eval
      end # each

      # 3. For each monster, the `initialize' method
      #    should use the default number for each trait.
      class_eval do
        define_method( :initialize ) do
          self.class.traits.each do |k,v|
            instance_variable_set("@#{k}", v)
          end # each
        end # define_method
      end # class_eval

    end # def self.traits
  end # class Traitable

  # Any non-monster you can interact with in the game
  class Item < Traitable
    traits :interactable_as, :name

    # Name of the item
    def to_s
      name
    end # def to_s

    # Defaults
    name "Item"
    interactable_as :item
  end # class Item

  # SRSGame::I is a shortcut for SRSGame::Item
  I = Item

  class Location; end; # :nodoc:
  # SRSGame::L is a shortcut for SRSGame::Location
  L = Location

  # Anywhere you can 'go' in the game
  class Location
    # Directions and their opposites
    def self.direction_relationships
      [["north", "south"], ["east", "west"], ["up", "down"], ["in", "out"]]
    end # def self.direction_relationships

    # Directions and their opposites and their opposites and their opposites
    def self.mirrored_directions
      direction_relationships + direction_relationships.map { |a| a.reverse }
    end # def self.mirrored_directions

    # All directions available
    def self.directions
      direction_relationships.flatten
    end # def self.directions

    # Title of the room (default: "a room")
    attr_accessor :name
    # Description of the item. Displayed when the name is regarded.
    attr_accessor :description
    # Items available in the room. Stored in @items.
    attr_accessor :items
    attr_accessor :block
    attr_reader(*L.directions)
    # Block called every time room is entered.
    attr_reader :on_enter

    # &block(self) is called on initialization
    def initialize(params = {}, &block)
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

    # Set <tt>@on_enter</tt> to &b
    def on_enter(&b)
      @on_enter = b
    end # def on_enter

    # Set <tt>@on_leave</tt> to &b
    def on_leave(&b)
      @on_leave = b
    end # def on_leave

    # Call <tt>@on_enter</tt>
    def enter
      puts info
      @on_enter.call(self) if @on_enter
    end # def enter

    # Call <tt>@on_leave</tt>
    def leave
      @on_leave.call(self) if @on_leave
    end # def leave

    # Information displayed when a room is entered.
    def info
      o = "You find yourself #{@name}. "
      o << "#{@description}. " if @description.unblank?
      o << "\nItems here are #{@items.map(&:to_s).to_sentence(:bold => true)}." if @items.unblank?
      o << "\nExits are #{exits.to_sentence(:bold => true)}." if exits.unblank?
      o
    end # def info

    def to_s
      "#<SRSGame::Location #{@name.inspect} @items=#{@items.inspect} exits=#{exits.inspect}>"
    end # def to_s
  end # class Location

  class Settings; end; # :nodoc:
  # SRSGame::S is a shortcut for SRSGame::Settings
  S = Settings

  # Game settings are stored in Settings.env
  class Settings
    class << self
      attr_reader :env

      # Add what we are seeding to <tt>@env</tt>
      def seed(seed)
        @env ||= default_settings
        @env << seed
        self
      end # def seed

      # <tt>S[:foo]</tt> is the same as <tt>S.env["FOO"]</tt>
      def [](key)
        @env[key.to_s.upcase]
      end # def []
    end # class << self

    # SRS GAME's default settings
    def self.default_settings
      {
        "GREETING_SPEED" => 20,
        "SAYS_HOWDY_PARTNER" => false,
        "MATCHES_SHORT_METHODS" => true
      }
    end # def self.default_settings
  end # class Settings

  # Class methods beginning with `<tt>_</tt>' are available as commands during the game
  class Commands
    class << self
      # Called when a non-existing command is entered during the game
      def method_missing(m, a)
        puts "#{self}::#{m.downcase}: not found".red
      end # def method_missing

      # Methods that start with `<tt>_</tt>' and don't end with `<tt>_</tt>'
      def callable_methods
        methods.grep(/^_\w+[^_]$/)
      end # def callable_methods

      # From GoRuby link:https://github.com/ruby/ruby/blob/trunk/golf_prelude.rb
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

      # Parse input and <tt>__send__</tt> it
      def parse(input)
        method = input.words.first
        argument_string = input.remove_first_word
        __send__("_" + method.command_pp, argument_string)
      end

      #################################
      # Methods available as commands #
      #################################

      # Define all directions as commands
      L.directions.each do |dir|

        define_method("_#{dir}") do |args|
          if $room.exits.include?(dir)
            $room = $room.__send__(dir)
          else
            puts "NOPE. Can't go that way."
          end # if
        end # define_method

      end # each

      # Quit the game
      def _exit(r)
        exit
      end

      # Prints $room.info
      def _look(r)
        puts $room.info
      end

      # Look at items
      def _look_item(r)
        puts "Room's items: #{$room.items}"
        puts "Items that match #{r.inspect}: #{$room.items.select { |item| item.interactable_as.to_s =~ Regexp.new(r, :i) }}"
      end

      # Display help text
      def _help(r)
        puts "For help on a specific command, use `man [command]'".red.strikethrough + " " + "COMING SOON".underline
        puts "For a list of all commands, use `help --all'"
        puts "All available commands:\n#{callable_methods.map(&:command_pp).to_sentence(:bold => true)}" if r =~ /--all/
      end # def _help

      # Alias commands
      alias :_quit :_exit
      alias :_? :_help
    end # class << self
  end # class Commands

  # Main loop
  def self.play(middleware, env = {})
    raise "No middleware for SRSGame.play" unless middleware
    extend middleware

    Settings.seed(env)

    rainbow_say(greeting)

    $room = main_room
    command = middleware.const_get(:Commands)

    Readline.completion_append_character = " "
    puts "Howdy, partner!" if S[:says_howdy_partner].to_s.to_bool
    if S[:matches_short_methods].to_bool
      completion_proc = proc { |s| command.matching_methods(s).map(&:command_pp) }
      Readline.completion_proc = completion_proc
    end # if

    @last_room = nil

    loop do
      $room.enter unless $room.eql? @last_room
      @last_room = $room

      input = Readline.readline("$ ", true)

      command.parse(input) unless input.blank?
    end # loop
  end # def self.play
end # module SRSGame
