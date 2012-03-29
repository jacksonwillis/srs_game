#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

require "simplecov"
SimpleCov.start

require "cucumber/formatter/unicode"
require "rspec/expectations"

$LOAD_PATH.unshift File.expand_path("../../../lib", __FILE__)

require "srs_game"
include SRSGame
require "srs_game/basic"
