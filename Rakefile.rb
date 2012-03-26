#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "srs_game"
include SRSGame

require "rake"

namespace :play do
  desc "Play as a follower of the Cult of Tia"
  task :tia do
    require "srs_game/tia"
    Game.new(Tia).play
  end

  desc "Play as the goddess Tamera"
  task :tamera do
    require "srs_game/tamera"
    Game.new(Tamera).play
  end
end

require "cucumber/rake/task"
Cucumber::Rake::Task.new
task :default => :cucumber
