#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

Given /^I have a value (.*)$/ do |value|
  @value = eval(value)
end

Given /^I have a string (.*)$/ do |value|
  @value = value
end

When /^I parse the string into arguments/ do
  @result = @value.args
end

When /^I parse the string into a boolean/ do
  @result = @value.to_bool
end

Then /^it should return (.*)$/ do |value|
  @result.should == eval(value)
end
