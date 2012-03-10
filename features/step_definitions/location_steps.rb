#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("../../../lib", __FILE__)
require "srs_game"
include SRSGame

Given /I have a room/ do
  @location = L.new
end

Given /I have an example room with blank rooms in each direction/ do
  @location = L.new
  L.directions.each { |dir| @location.__send__("#{dir}=", L.new) }
end

And /I added an item to the room/ do
  @item = I.new
  @location.items << @item
end

Then /the room should contain an item/ do
  @location.items.include? @item
end

Then /the room to west of east room is the main room/ do
  @location.eql? @location.west.east
end

Then /the room's exits include all directions/ do
  @location.exits.eql? L.directions
end
