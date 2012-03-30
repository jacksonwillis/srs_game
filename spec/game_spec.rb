#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("../", __FILE__)
require "spec_helper"

describe SRSGame::Game do
  it "has a room" do
    Game.new.room.should be_instance_of Location
  end

  describe "#go!" do
    it "travels" do
      game = Game.new

      kitchen  = Location.new
      basement = Location.new { |l| l.up = kitchen }
      sidewalk = Location.new { |l| l.in = kitchen }
      bus_stop = Location.new { |l| l.north = sidewalk }

      game.room = basement
      ->{game.go! :up, :out, :south}.should change {game.room}.from(basement).to(bus_stop)
    end
  end
end
