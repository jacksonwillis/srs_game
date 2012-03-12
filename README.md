SRS GAME
========

[![Build Status](https://secure.travis-ci.org/jacksonwillis/srs_game.png?branch=master)](https://secure.travis-ci.org/jacksonwillis/srs_game)

![SRS GAME logo](https://github.com/jacksonwillis/srs_game/raw/master/srs_game.png)

Welcome
-------

SRS GAME is a framework and a collection of text-based games written in the [Ruby](http://www.ruby-lang.org/) 1.9 programming language.

If you find a bug, feel free to [create an issue](https://github.com/jacksonwillis/srs_game/issues/new).

Installation
------------

_Main article:_ [Installation](https://github.com/jacksonwillis/srs_game/wiki/Installation)

    $ git clone git://github.com/jacksonwillis/srs_game.git
    $ cd srs_game
    $ gem install bundler
    $ bundle install

Playing the game
----------------

### Without Rake

Just execute the file!

    $ lib/srs_game/tamera.rb   # Play as the goddess Tamera
    $ lib/srs_game/tia.rb      # Play as a follower of the Cult of Tia
### With Rake

    $ rake play:tamera   # Play as the goddess Tamera
    $ rake play:tia      # Play as a follower of the Cult of Tia

SRS GAME, with Rake, takes arguments on the command line. For example:

    $ rake play:tamera SAYS_HOWDY_PARTNER=true

The default settings are defined in [Settings::default_settings](https://rdoc.info/github/jacksonwillis/srs_game/master/SRSGame/Settings.default_settings).

Testing
-------

To test, just run

    $ rake cucumber

or check out the [automated tests](https://secure.travis-ci.org/jacksonwillis/srs_game).

Extension
---------

Check out
SRSGame::Tamera
([Github](https://github.com/jacksonwillis/srs_game/blob/master/lib/srs_game/tamera.rb),
   [RDoc](http://rubydoc.info/github/jacksonwillis/srs_game/master/SRSGame/Tamera))
and [examples/pokemon_clone.rb](https://github.com/jacksonwillis/srs_game/blob/master/examples/pokemon_clone.rb)
for examples of playable modules.

License
-------

SRS GAME is released under the zlib license. See [LICENSE](https://github.com/jacksonwillis/srs_game/blob/master/LICENSE)
