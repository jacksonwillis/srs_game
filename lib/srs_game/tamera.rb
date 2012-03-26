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

  class Radio < Item
    name "an AM/FM Radio"
    interactable_as :radio
  end

  # Room where you begin in
  def main_room
    main = L.new do |l|
      l.name = "in the Main Room",
      l.items = [Radio.new]
    end

    main.east = L.new do |l|
      l.name = "in the East Room",
      l.items = [BallaAssSpoon.new, CrystalBall.new]
    end

    dungeon = main.east.south = L.new do |l|
      l.name = "a creepy dungeon"
    end

    dungeon.south = L.new do |l|
      l.name = "Hell"
    end

    west_room = main.west = L.new do |l|
      l.name = "the West Room"
    end

    far_west = west_room.west = L.new do |l|
      l.name = "the Far West Room"
    end

    far_west.north = L.new do |l|
      l.name = "the North West Room"
    end

    return main
  end

  # Emitted before the game starts
  def greeting
    "\n #####   #####     ##       #     ####   ######\n #    #  #    #   #  #      #    #       #\n #    #  #    #  #    #     #     ####   #####\n #####   #####   ######     #         #  #\n #       #   #   #    #     #    #    #  #\n #       #    #  #    #     #     ####   ######\n\n\n #####   ######\n #    #  #\n #####   #####\n #    #  #\n #    #  #\n #####   ######\n\n\n  #####   ####\n    #    #    #\n    #    #    #\n    #    #    #\n    #    #    #\n    #     ####\n\n\n  #####    ##    #    #  ######  #####     ##\n    #     #  #   ##  ##  #       #    #   #  #\n    #    #    #  # ## #  #####   #    #  #    #\n    #    ######  #    #  #       #####   ######\n    #    #    #  #    #  #       #   #   #    #\n    #    #    #  #    #  ######  #    #  #    #\n\n"
  end
end

SRSGame.play Tamera if __FILE__ == $0
