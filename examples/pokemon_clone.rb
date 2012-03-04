#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("lib")

require "srs_game"

include SRSGame

module PokemonClone
  class Computer < Item
    def use
      puts "Using computer"
    end
  end

  class Bed < Item
    def use
      puts "Sleeping in computer"
    end
  end

  def greeting
    "      /\"*-.\n" << \
    "     /     `-.\n" << \
    "    /         `-.\n" << \
    "   /             `-.\n" << \
    "   `\"*-._           `-.\n" << \
    "         \"*-.      .-'\n" << \
    "           .-'  .-'\n" << \
    "         <'   <'\n" << \
    "          `-.  `-.           .\n" << \
    "            .'  .-'          $\n" << \
    "     _    .' .-'     bug    :$;\n" << \
    "     T$bp.L.-*\"\"*-._        d$b\n" << \
    "      `TP `-.       `-.    : T$\n" << \
    "     .' `.   `.        `.  ;  ;\n" << \
    "    /     `.   \\ _.      \\:  :\n" << \
    "   /        `..-\"         ;  |\n" << \
    "  :          /               ;\n" << \
    "  ;  \\      / _             :\n" << \
    " /`--'\\   .' $o$            |\n" << \
    "/  /   `./-, `\"'      _     :\n" << \
    "'-'     :  ;  _ '    $o$    ;\n" << \
    "        ;Y\"   |\"-.   `\"'   /\n" << \
    "        | `.  L.'    .-.  /`*.\n" << \
    "        :   `-.     ;   :'    \\\n" << \
    "         ;    :`*-._L.-'`-.    :\n" << \
    "         :    ;            `-.*\n" << \
    "          \\  /\n" << \
    "           \"\" ~* PokemonClone.rb *~"
  end

  def main_room
    house = L.new(:name => "outside your house")
    house.in = L.new(:name => "in your living room", :on_enter => -> { puts "Your mother greets you: \"Good morning, Red!\"" })
    house.in.up = L.new(:name => "at the top of your stairs")

    room = house.in.up.north = L.new(:name => "at the threshold your room")
    room.north = L.new(:name => "standing in the middle of your room", :items => [Bed.new])
    room.north.west = L.new(:name => "at your computer", :items => [Computer.new])
    room.north.east = L.new(:name => "in your neatly made single bed")

    house.south = L.new(:name => "at the Pallet Town plaza")
    house
  end

  class Commands < SRSGame::Commands; class << self

  end; end
end

SRSGame.play PokemonClone if __FILE__ == $0
