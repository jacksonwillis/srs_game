SRS GAME
========

[![Build Status](https://secure.travis-ci.org/jacksonwillis/srs_game.png?branch=master)](https://secure.travis-ci.org/jacksonwillis/srs_game)
[![Dependency Status](https://gemnasium.com/jacksonwillis/srs_game.png)](https://gemnasium.com/jacksonwillis/srs_game)

![SRS GAME logo](https://github.com/downloads/jacksonwillis/srs_game/srs_game.png)

Welcome
-------

SRS GAME is a framework and a collection of text-based games written in the [Ruby](http://www.ruby-lang.org/) 1.9 programming language.

SRS GAME is currently at version [0.1.1](https://github.com/jacksonwillis/srs_game) (codename Alexis) on branch master,
and [0.2.0-dev](https://github.com/jacksonwillis/srs_game/tree/development)  (codename Alice) on branch development.

If you find a bug, feel free to [create an issue](https://github.com/jacksonwillis/srs_game/issues/new).

For more information, see the [wiki](https://github.com/jacksonwillis/srs_game/wiki/).

API
---

See [API](https://github.com/jacksonwillis/srs_game/wiki/API) at the wiki

    irb > require "srs_game/tamera"
     => true
    irb > game = Game.new(Tamera, color: false)
     => #<SRSGame::Game:0x000000022f1337>
    irb > game.send "look"
     => "You find yourself in the Main Room.\nItems here are an AM/FM Radio.\nExits are east and west."
    irb > game.send "north"
     => "NOPE. Can't go that way."
    irb > game.send "west"
     => ""
    irb > game.room
     => #<SRSGame::Location "the West Room" @items=[] exits=["east", "west"]>

License
-------

SRS GAME is released under the zlib license. See [LICENSE](https://github.com/jacksonwillis/srs_game/blob/master/LICENSE)
