#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("../", __FILE__)
require "spec_helper"

describe "helpers" do
  it "determines blankness" do
    [].blank?.should be_true
    "".blank?.should be_true
    false.blank?.should be_true
    true.blank?.should be_false
    3.14.blank?.should be_false
    nil.unblank?.should be_false
    "foo".unblank?.should be_true
  end

  it "formats commands" do
    "_baz".command_pp.should eq "baz"
    :_Senate.command_pp.should eq "senate"
  end

  it "converts arrays to sentences" do
    [1,2,3].to_sentence.should eq "1, 2, and 3"
    ["jack", "jill"].to_sentence.should eq "jack and jill"
    ["Something"].to_sentence.should eq "Something"
    [].to_sentence.should eq ""
    ["Kinada", "Dwor", "apple", "green"].to_sentence(bold: true).should eq \
      "\e[1mKinada\e[0m, \e[1mDwor\e[0m, \e[1mapple\e[0m, and \e[1mgreen\e[0m"
  end

  it "converts string to booleans" do
    "yes".to_bool.should be_true
    "no".to_bool.should be_false
    "f".to_bool.should be_false
    "t".to_bool.should be_true
    "true".to_bool.should be_true
    "foo".to_bool.should be_nil
  end

  it "identifies if a string represents a boolean" do
    "yes".boolean?.should be_true
    "false".boolean?.should be_true
    "foo".boolean?.should be_false
  end

  it "identifies if a string represents a numeric" do
    "3.14".numeric?.should be_true
    "42".numeric?.should be_true
    "4.2e2".numeric?.should be_true
    "foo".numeric?.should be_false
  end

  it "parses a string into arguments" do
    "3.14 yes gaga false".args.should eq [3.14, true, "gaga", false]
    "tia".args.should eq ["tia"]
    "".args.should eq []
    "           ".args.should eq []
  end

end
