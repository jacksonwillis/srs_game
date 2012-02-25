# -*- coding: UTF-8 -*-

module SRSGame::Tamera
  def main_room
    main = L.new(:name => "the Main Room")
    main.east = L.new(:name => "the East Room", :items => [I.new(:name => "Balla Ass Spoon")])
    main.east.south = L.new(:name => "a creepy dungeon")
    main.east.south.south = L.new(:name => "Hell") { |room| room.on_enter { rainbow_say "Welcome\nto\nHell!" * 8 } }
    main.west = L.new(:name => "the West Room")
    main.west.west = L.new(:name => "the Far West Room")
    main.west.west.north = L.new(:name => "the North West Room")
    main
  end

  def greeting
    base64_zlib_inflate "eJydUdEKACEIe/crhP3/Px6V2XJyByeEpmsuNccw9/Qj8mX7euqwlYSnz5hS0yuU6kptogQkybfhMJ/+wowe+ikCZkUHf6OUTNo0oMl4payo/H934Y/dpZjI8275eQwPccqk4jsy0wEm0nuwhN/NuS7r7fgL/trxC77rB3sAsstclA=="
  end

  class Commands < SRSGame::Commands
    def _exit(r)
      exit
    end
  end
end
