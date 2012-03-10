#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

Given /^I have a value (.*)$/ do |v|
  @value = eval(v)
end

Then /^its blankness should match (.*)$/ do |arg1|
  @value.blank?.should == eval(arg1)
end
