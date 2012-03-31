#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

$LOAD_PATH.unshift File.expand_path("../lib/", __FILE__)
require "srs_game/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Jackson Willis"]
  gem.email         = ["jcwillis.school@gmail.com"]
  gem.description   = "A framework and collection of text-based games"
  gem.summary       = "A framework and collection of text-based games"
  gem.homepage      = "http://github.com/jacksonwillis/srs_game"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "srs_game"
  gem.require_paths = ["lib"]
  gem.version       = SRSGame::VERSION
end
