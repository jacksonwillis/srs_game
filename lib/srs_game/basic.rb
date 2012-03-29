#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("../../", __FILE__)
require "srs_game"
include SRSGame

module SRSGame::Basic
  def main_room
    L.new
  end
end
