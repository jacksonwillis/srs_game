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
  end
end
