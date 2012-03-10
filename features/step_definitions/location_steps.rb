#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

Given /I have a room/ do
  @location = L.new
end

When /I add blank rooms in each direction/ do
  @location = L.new
  L.directions.each { |dir| @location.__send__("#{dir}=", L.new) }
end

When /I added an item to the room/ do
  @item = I.new
  @location.items << @item
end

Then /the room should contain an item/ do
  @location.items.include? @item
end

Then /the room to (\w+) of the (\w+) room is the main room/ do |direction, room|
  @location == @location.__send__(room).__send__(direction)
end

Then /the room's exits include all directions/ do
  @location.exits == L.directions
end
