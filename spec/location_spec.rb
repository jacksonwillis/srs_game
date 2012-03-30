#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("../", __FILE__)
require "spec_helper"

describe SRSGame::Location do
  it "instantiates rooms" do
    name = "some room"

    location = Location.new do |l|
      l.name = name
    end

    location.name.should eq name
  end

  describe "#info" do
    it "describes a room" do
      class SomeItem < Item
        name "some item"
      end

      location = Location.new do |l|
        l.name = "in a room"
        l.items = [SomeItem.new]
        l.south = L.new
        l.out = L.new
      end

      location.info.uncolored.should eq "You find yourself in a room.\nItems here are some item.\nExits are south and out."
    end
  end
end
