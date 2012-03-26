#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "srs_game"
include SRSGame

module PokemonClone
  class Computer < Item
    interactable_as :computer
    name "red's computer"
  end

  class Bed < Item
    interactable_as :bed
    name "YOUR BED"
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
    "           \"\" ~* PokemonClone.rb *~\n"
  end

  def main_room
    house = L.new(:name => "outside your house")
    house.in = L.new(:name => "in your living room")
    house.in.up = L.new(:name => "at the top of your stairs")

    room = house.in.up.north = L.new(:name => "at the threshold your room")
    room.north = L.new(:name => "standing in the middle of your room", :items => [Bed.new])
    room.north.west = L.new(:name => "at your computer", :items => [Computer.new])

    house.south = L.new(:name => "at the Pallet Town plaza")
    house
  end

  class Commands < SRSGame::Commands; end
  class << Commands

  end
end

SRSGame.play PokemonClone if __FILE__ == $0
