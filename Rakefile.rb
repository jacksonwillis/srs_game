#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

require "rake"

$LOAD_PATH.unshift File.expand_path("lib")
require "srs_game"

namespace :play do
  desc "Play as a follower of the Cult of Tia"
  task :tia do
    require "srs_game/tia"
    SRSGame.play SRSGame::Tia, ENV
  end

  desc "Play as the goddess Tamera"
  task :tamera do
    require "srs_game/tamera"
    SRSGame.play SRSGame::Tamera, ENV
  end
end

require "cucumber/rake/task"
Cucumber::Rake::Task.new
task :default => :cucumber
