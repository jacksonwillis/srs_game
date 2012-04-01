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

  gem.files         = ["lib/srs_game/tia.rb", "lib/srs_game/tamera.rb", "lib/srs_game/version.rb", "lib/srs_game/basic.rb", "lib/srs_game.rb"]
  gem.name          = "srs_game"
  gem.require_paths = ["lib"]
  gem.version       = "0.1.2-dev"

  gem.add_dependency("term-ansicolor", "~> 1.0.7")
  gem.add_development_dependency("rake", "~> 0.9.2.2")
end
