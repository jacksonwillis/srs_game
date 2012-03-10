#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("../../", __FILE__)
require "srs_game"
include SRSGame

# Play as the goddess Tamera
module SRSGame::Tamera
  class BallaAssSpoon < Item
    name "a Balla Ass Spoon"
    interactable_as :spoon
  end

  class CrystalBall < Item
    name "a Crystal Ball"
    interactable_as :crystal
  end

  # Room where you begin in
  def main_room
    main = L.new(:name => "the Main Room")
    main.east = L.new(:name => "the East Room", :items => [BallaAssSpoon.new, CrystalBall.new])
    main.east.south = L.new(:name => "a creepy dungeon")
    main.east.south.south = L.new(:name => "Hell") { |room| room.on_enter { rainbow_say "Welcome\nto\nHell!\n" * 8 } }
    main.west = L.new(:name => "the West Room")
    main.west.west = L.new(:name => "the Far West Room")
    main.west.west.north = L.new(:name => "the North West Room")
    main
  end

  # Emitted before the game starts
  def greeting
    "\n #####   #####     ##       #     ####   ######\n #    #  #    #   #  #      #    #       #\n #    #  #    #  #    #     #     ####   #####\n #####   #####   ######     #         #  #\n #       #   #   #    #     #    #    #  #\n #       #    #  #    #     #     ####   ######\n\n\n #####   ######\n #    #  #\n #####   #####\n #    #  #\n #    #  #\n #####   ######\n\n\n  #####   ####\n    #    #    #\n    #    #    #\n    #    #    #\n    #    #    #\n    #     ####\n\n\n  #####    ##    #    #  ######  #####     ##\n    #     #  #   ##  ##  #       #    #   #  #\n    #    #    #  # ## #  #####   #    #  #    #\n    #    ######  #    #  #       #####   ######\n    #    #    #  #    #  #       #   #   #    #\n    #    #    #  #    #  ######  #    #  #    #\n\n"
  end
end

SRSGame.play Tamera if __FILE__ == $0
