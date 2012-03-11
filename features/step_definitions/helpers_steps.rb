#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

Given /^I have a value (.*)$/ do |value|
  @value = eval(value)
end

When /^I parse the string into arguments/ do
  @result = @value.args
end

Then /^it should return (.*)$/ do |value|
  @result.should == eval(value)
end
