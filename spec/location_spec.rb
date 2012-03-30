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
    location.inspect.should be_an_instance_of(String)
  end

  describe "#do" do
    it "only lets you occupy reality" do
      location = Location.new # no exits
      ->{location.go("west")}.should raise_error SRSGame::DirectionError
      ->{location.go(:down)}.should raise_error SRSGame::DirectionError
    end
  end

  describe "#info" do
    it "describes a room" do
      class SomeItem < Item
        name "some item"
      end

      location = Location.new do |l|
        l.name = "in a room"
        l.description = "A picture hangs on the wall."
        l.items = [SomeItem.new]
        l.south = L.new
        l.out = L.new
      end

      location.info.uncolored.should eq "You find yourself in a room. A picture hangs on the wall." <<
                                        "\nItems here are some item.\nExits are south and out."
    end
  end

  it "looks for items" do
    class FooItem < Item
      interactable_as :foo
    end

    class BarItem < Item
      interactable_as :bar
    end

    foo = FooItem.new
    bar = BarItem.new

    location = Location.new { |l| l.items = [foo, bar] }

    location.item_grep("foo").should eq [foo]
    location.item_grep("bar").should eq [bar]
    location.item_grep("baz").should eq []
    location.item_grep("").should eq []
  end

  it "has a prompt" do
    Game.new.prompt.should eq "$ "
  end
end
