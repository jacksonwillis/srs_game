#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "srs_game"
require "rake"

namespace :play do
  desc "Play as a follower of the Cult of Tia"
  task :tia do
    require "srs_game/tia"
    Game.new(Tia, color: true).play
  end

  desc "Play as the goddess Tamera"
  task :tamera do
    require "srs_game/tamera"
    Game.new(Tamera, color: true).play
  end
end

namespace :server do
  desc "Telnet server for Tia"
  task :tia do
    require "srs_game/tia"
    SRServer.play(Tia, ENV["PORT"], ENV["HOST"], ENV["MAX_CONNECTIONS"])
  end

  desc "Telnet server for Tamera"
  task :tamera do
    require "srs_game/tamera"
    SRServer.play(Tamera, ENV["PORT"], ENV["HOST"], ENV["MAX_CONNECTIONS"])
  end
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new

task :default => :spec
