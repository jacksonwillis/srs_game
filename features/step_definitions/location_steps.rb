# encoding: utf-8

require "cucumber/formatter/unicode"

$:.unshift(File.expand_path(File.dirname(__FILE__) + "/../../lib"))

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
