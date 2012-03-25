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
    # TODO: Store this information in a better way.

    main = \
      L.new(
        name: "in the Main Room",
        items: [Radio.new])

    main.east = \
      L.new(
        name: "in the East Room",
        items: [BallaAssSpoon.new, CrystalBall.new])

    dungeon = \
      main.east.south = \
        L.new(
          name: "a creepy dungeon")

    dungeon.south = \
      L.new(
        name: "Hell")

    west_room = \
      main.west = \
        L.new(
          name: "the West Room")

    far_west = \
      west_room.west = \
        L.new(
          name: "the Far West Room")

    far_west.north = \
      L.new(
        name: "the North West Room")

    return main
  end

  # Emitted before the game starts
  def greeting
    "\n #####   #####     ##       #     ####   ######\n #    #  #    #   #  #      #    #       #\n #    #  #    #  #    #     #     ####   #####\n #####   #####   ######     #         #  #\n #       #   #   #    #     #    #    #  #\n #       #    #  #    #     #     ####   ######\n\n\n #####   ######\n #    #  #\n #####   #####\n #    #  #\n #    #  #\n #####   ######\n\n\n  #####   ####\n    #    #    #\n    #    #    #\n    #    #    #\n    #    #    #\n    #     ####\n\n\n  #####    ##    #    #  ######  #####     ##\n    #     #  #   ##  ##  #       #    #   #  #\n    #    #    #  # ## #  #####   #    #  #    #\n    #    ######  #    #  #       #####   ######\n    #    #    #  #    #  #       #   #   #    #\n    #    #    #  #    #  ######  #    #  #    #\n\n"
  end
end

SRSGame.play Tamera if __FILE__ == $0
