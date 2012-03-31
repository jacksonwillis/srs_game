SRS GAME
========

[![Build Status](https://secure.travis-ci.org/jacksonwillis/srs_game.png?branch=master)](https://secure.travis-ci.org/jacksonwillis/srs_game)
[![Dependency Status](https://gemnasium.com/jacksonwillis/srs_game.png)](https://gemnasium.com/jacksonwillis/srs_game)

![SRS GAME logo](https://github.com/downloads/jacksonwillis/srs_game/srs_game.png)

Welcome
-------

SRS GAME is a framework and a collection of text-based games written in the [Ruby](http://www.ruby-lang.org/) 1.9 programming language.

If you find a bug, feel free to [create an issue](https://github.com/jacksonwillis/srs_game/issues/new).

Installation
------------

*Main article: [Installation](https://github.com/jacksonwillis/srs_game/wiki/Installation)*

Playing the game
----------------

    $ rake play:tamera   # Play as the goddess Tamera
    $ rake play:tia      # Play as a follower of the Cult of Tia

Running a server
----------------

    $ rake server:tamera HOST=127.0.0.1 PORT=5446 MAX_CONNECTIONS=4

Testing
-------

To test, just run `rake`
or check out the [automated tests](https://secure.travis-ci.org/jacksonwillis/srs_game).

API
---

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
