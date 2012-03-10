#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("lib")

require "rake"
require "cucumber/rake/task"
require "srs_game"

Cucumber::Rake::Task.new(:features)

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

task :default => "features"
