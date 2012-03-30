#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("../", __FILE__)
require "spec_helper"

describe SRSGame::SRServer do
  describe "::new" do
    it "makes a default server" do
      server = SRServer.new Basic
      server.mod.should eq Basic
      server.host.should eq SRServer::DEFAULT_HOST
      server.port.should eq SRServer::DEFAULT_PORT
      server.maxConnections.should eq SRServer::MAX_CONNECTIONS
    end
  end
end
