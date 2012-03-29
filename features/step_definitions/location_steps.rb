#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

Given /I have a room/ do
  @room = Location.new
end

Given /I have an item/ do
  @item = Item.new
end

Given /I have a basic game with no rooms/ do
  @game = Game.new(Basic)
  @room = @game.room
end

When /I add blank rooms in each direction/ do
  @room = Location.new
  Location.directions.each { |dir| @room.__send__("#{dir}=", L.new) }
end

When /I add the item to the room/ do
  @room.items << @item
end

When /I add a room to the (\w+) called "([^"]*)"/ do |direction, name|
  @room.__send__("#{direction}=", Location.new(:name => name))
end

When /I go (\w+)/ do |direction|
  @room = @room.go direction
end

Then /the room should contain an item/ do
  @room.items.should include @item
end

Then /^the name of the room is "([^"]*)"$/ do |name|
  @room.name.should eq name
end

Then /the room to (\w+) of the (\w+) room is the main room/ do |direction, room|
  @room.should eq @room.__send__(room).__send__(direction)
end

Then /the room's exits include all directions/ do
  @room.exits.should eq Location.directions
end
