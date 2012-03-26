#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

require "zlib"
require "base64"
require "readline"
require "gserver"
require "term/ansicolor"

include Term::ANSIColor

class Object
  # Returns true for false, nil, and empty values.
  # Returns false otherwise.
  # @return [Boolean]
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  # Opposite of Object#blank?
  # @return [Boolean]
  def unblank?
    !self.blank?
  end

  # Removes "_" from beginning of line and dowmcases it
  def command_pp
    to_s.gsub(/^_/, "").downcase
  end

  # From ActiveSupport[http://api.rubyonrails.org/classes/Array.html#method-i-to_sentence].
  # Converts the array to a comma-separated sentence where the last element is joined by the connector word. Options:
  # * :words_connector:: - The sign or word used to join the elements in arrays with two or more elements (default: ", ")
  # * :two_words_connector:: - The sign or word used to join the elements in arrays with two elements (default: " and ")
  # * :last_word_connector:: - The sign or word used to join the last element in arrays with three or more elements (default: ", and ")
  # * :bold:: - Bolds the elements being joined. (default: false)
  # @return [String]
  def to_sentence(options = {})
    words_connector     = options[:words_connector]     || ", "
    two_words_connector = options[:two_words_connector] || " and "
    last_word_connector = options[:last_word_connector] || ", and "

    if options[:bold]
      respond_to? :map! or return to_sentence Array[self]

      map!(&:to_s)
      map!(&:bold)
    end

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
  # Words that become true when to_bool is called
  TRUE_WORDS = %w{t true yes y}
  # Words that become false when to_bool is called
  FALSE_WORDS = %w{f false no n}

  # Convert to boolean value
  # @return [Boolean, nil]
  def to_bool
    dc = to_s.downcase

    if TRUE_WORDS.include?(dc)
      true
    elsif FALSE_WORDS.include?(dc)
      false
    # return nil if neither case is matched
    end
  end

  # Can the string be converted to a boolean value?
  # @return [Boolean]
  def boolean?
    !to_bool.nil?
  end

  # Does the string represent a numeral in Ruby?
  # @return [Boolean]
  def numeric?
    !!Float(self) rescue false
  end

  # Turn the string in to an array of arguments.
  # It tries to convert words into booleans and floats. Example:
  #     "3.14 yes gaga false".args #=> [3.14, true, "gaga", false]
  # @return [Array]
  def args
    strip.words.map do |arg|
      next if arg.empty?

      if arg.boolean?
        arg.to_bool
      elsif arg.numeric?
        Float(arg)
      else
        arg
      end
    end
  end

  # Is self.args unempty?
  # @return [Boolean]
  def args?
    !args.empty?
  end

  # Scans the string for groups of non-whitespace characters.
  # @return [Array]
  def words
    scan(/\S+/)
  end

  # Removes the first group of non-whitespace characters.
  # @return [String]
  def remove_first_word
    gsub(/^\S+\s*/, "")
  end
end

class Hash
  # Add two hashes. Does not overwrite pre-existing values.
  # @return [Hash]
  def +(add)
    temp = {}
    add.each { |k, v| temp[k] = v}
    self.each { |k, v| temp[k] = v}
    temp
  end

  # Add two hashes. Overwrites pre-existing values, and is destructive.
  # @return [Hash]
  def <<(add)
    temp = {}
    self.each { |k, v| temp[k] = v}
    add.each { |k,v| temp[k] = v}
    replace temp
  end
end

module SRSGame
  class DirectionError < ::ArgumentError; end

  # Helpful methods that are included throught out the project
  module Helpers
    # Compress and base64 encode a string
    def base64_zlib_deflate(s)
      Base64.encode64(Zlib::Deflate.deflate(s, Zlib::BEST_COMPRESSION))
    end

    # Base64 decode and decompress and a string
    def base64_zlib_inflate(s)
      Zlib::Inflate.inflate(Base64.decode64(s))
    end

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
        end
        sleep 1.0 / greeting_speed
      end
    end
  end

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

      # 3. For each traitable object, the `initialize' method
      #    should use the default number for each trait.
      class_eval do
        define_method( :initialize ) do
          self.class.traits.each do |k,v|
            instance_variable_set("@#{k}", v)
          end
        end
      end

    end
  end

  class Item < Traitable
    traits :interactable_as, # TODO: rename this trait
           :name,
           :description,
           :takeable

    # Defaults
    interactable_as :item
    name "an Item"
    description ""
    takeable false

    def to_s
      name
    end
  end

  # SRSGame::I is a shortcut for SRSGame::Item
  I = Item

  class Location; end
  # SRSGame::L is a shortcut for SRSGame::Location
  L = Location

  class Location
    def self.direction_relationships
      [["north", "south"], ["east", "west"], ["up", "down"], ["in", "out"]]
    end

    def self.mirrored_directions
      direction_relationships + direction_relationships.map { |a| a.reverse }
    end

    # All directions available
    def self.directions
      direction_relationships.flatten
    end

    attr_reader(*L.directions)
    attr_accessor :name
    attr_accessor :description
    attr_accessor :items

    def initialize(params = {}, &block)
      @name        = params[:name] || "a room"
      @description = params[:description].to_s
      @items       = params[:items].to_a

      block.call(self)
    end

    def item_grep(str)
      @items.select { |item| str == item.interactable_as.to_s.downcase }
    end

    def items_here
      "Items here are #{@items.map(&:to_s).to_sentence(:bold => true)}."
    end

    # We have to create our own setter methods to do the mirrored direction relationships
    L.mirrored_directions.each do |dir|
      direction, opposite = *dir
      define_method(direction + "=") do |loc|
        # set @direction to loc
        instance_variable_set "@" + direction, loc
        # _direction is @direction
        _direction = instance_variable_get("@" + direction)
        _direction.__send__(opposite + "=", self) unless _direction.__send__(opposite)
      end
    end

    # Available exits
    # @return [Array]
    def exits
      L.directions.select { |dir| __send__(dir) }
    end

    # Information displayed when a room is entered.
    def info
      o = "You find yourself #{@name.bold}. "
      o << "#{@description}. " if @description.unblank?
      o << "\n" << items_here if @items.unblank?
      o << "\nExits are #{exits.to_sentence(:bold => true)}." if exits.unblank?
      o
    end

    def go(direction)
      if L.directions.include?(direction)
        __send__(direction)
      else
        raise DirectionError, "Can't go #{direction} from #{@name}."
      end
    end

    def to_s
      "#<SRSGame::Location #{@name.inspect} @items=#{@items.inspect} exits=#{exits.inspect}>"
    end
  end

  # Class methods beginning with `+_+' are available as commands during the game
  class Commands
    class << self
      # Called when a non-existing command is entered during the game
      def method_missing(m, *a)
        "#{self}::#{m.downcase}: not found".red
      end

      # Methods that start with `+_+' and don't end with `+_+'
      def callable_methods
        methods.grep(/^_\w+[^_]$/)
      end

      # From GoRuby https://github.com/ruby/ruby/blob/trunk/golf_prelude.rb
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
        end
      end

      # Parse input and +__send__+ it
      def parse(input, game)
        method = input.words.first
        argument_string = input.remove_first_word
        __send__("_" + method.command_pp, argument_string, game)
      end

      #################################
      # Methods available as commands #
      #################################

      # Define all directions as commands
      L.directions.each do |direction|
        define_method("_#{direction}") do |a, g|
          begin
            g.go!(direction)
          rescue DirectionError => e
            e
          end
        end
      end

      # Quit the game
      def _exit(a, g)
        exit
      end

      # Prints $room.info
      def _look(a, g)
        case a
        when /^\s*$/i
          g.room.info
        else
          _look_item(a)
        end
      end

      # Look at items
      def _look_item(a, g)
        found = g.room.item_grep(a)

        if found.empty?
          g.room.items_here
        else
          found.each { |item| puts "You see #{item.name.bold}. " }.join("\n")
        end
      end

      # Display help text
      def _help(a, g)
        puts "For a list of all commands, use `help --all'"
        puts "All available commands:\n#{callable_methods.map(&:command_pp).to_sentence(:bold => true)}" if a =~ /--all/
      end

      # Alias commands
      alias :_quit :_exit
      alias :_? :_help
    end
  end

  class Game
    attr_accessor :room

    def initialize(mod, options = {})
      raise ArgumentError, "Can't use #{middleware} for SRSGame middleware" unless mod.is_a? Module
      extend mod

      @room = main_room
      #@travel_path = [@room]
      @command = mod.const_get(:Commands)
    end

    def go!(direction)
      @room = @room.go(direction)
    end

    #def current_room
    #  @travel_path[-1]
    #end

    #def last_room
    #  @travel_path[-2]
    #end

    #def same_room?
    #  current_room.eql? last_room
    #end

    def prompt
      "$ ".bold.blue
    end

    def send(input)
      @command.parse(input, self) unless input.blank?
    end

    def play(io)
      loop do
        input = io.readline(prompt, true)
        io.puts send(input) unless input.blank?
      end
    end
  end

  class SRServer < GServer
    # ♫ 54-46 was my number ♫
    DEFAULT_PORT = 54_46

    def initialize(mod, port = DEFAULT_PORT, *args)
      @mod = mod
      super(port, *args)
    end

    def serve(io)
      game = Game.new(@mod, direct: false)

      loop do
        io.print game.prompt
        input = io.readline
        io.puts game.send(input) unless input.blank?
      end
    end

    def self.play(*args)
      server = new(*args)
      server.audit = true
      server.start
      server.join
    end
  end
end
