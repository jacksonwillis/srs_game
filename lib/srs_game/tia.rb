#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

module SRSGame::Tia
  def main_room
    main = L.new(:name => "Main Room")
    main.east = L.new(:name => "East Room")
    main.east.south = L.new(:name => "South East Room")
    main.east.south.south = L.new(:name => "South South East Room")
    main.west = L.new(:name => "West Room")
    main.west.west = L.new(:name => "Far West Room")
    main.west.west.north = L.new(:name => "North West Room")
    main
  end
  def greeting
    base64_zlib_inflate "eJydUVEKQDEI+vcUgve/42MbWy2DweunMjEjUCPIk0fFFbuNubBA8eRTJ2hmp6a5S8OcKFniDoVy7Ddl9dSnCQHFRz6jjGBrGtJUvCAUl/97mn68ItPSvQ1sqhvS7fbJXzg+1sVJ3g=="
  end
end
