#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "../../../lib")

require "cucumber/formatter/unicode"
require "srs_game"

Before do
end

After do
end

Given /I have a room/ do
  @location = SRSGame::Location.new
end

And /I added an item to the room/ do
  @item = SRSGame::Item.new
  @location.items << @item
end

Then /the room should contain an item/ do
  @location.items.include? @item
end
