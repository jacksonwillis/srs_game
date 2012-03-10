#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

require "cucumber/formatter/unicode"
require "rspec/expectations"

$LOAD_PATH.unshift(File.expand_path(__FILE__ + "../../../../lib"))

require "srs_game"
include SRSGame
