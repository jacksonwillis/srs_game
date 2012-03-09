#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

require "rake"

################
# Cucumber     #
################

require "cucumber/rake/task"

namespace :cuke do
  Cucumber::Rake::Task.new(:run) do |task|
    task.cucumber_opts = ["features"]
  end
end

################
# Play         #
################

$LOAD_PATH.unshift File.expand_path("lib")
require "srs_game"
include SRSGame

namespace :play do
  desc "Play as a follower of the Cult of Tia"
  task :tia do
    require "srs_game/tia"
    SRSGame.play Tia, ENV
  end

  desc "Play as the goddess Tamera"
  task :tamera do
    require "srs_game/tamera"
    SRSGame.play Tamera, ENV
  end
end

################
# Default      #
################

task :default => "cuke:run"
