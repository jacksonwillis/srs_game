module SRSGame::Tamera
  def main_room
    main = L.new(:name => "Main Room")
    main.east = L.new(:name => "East Room") { puts "Welcome to the East Room!" }
    main.east.south = L.new(:name => "South East Room")
    main.east.south.south = L.new(:name => "South South East Room")
    main.west = L.new(:name => "West Room")
    main.west.west = L.new(:name => "Far West Room")
    main.west.west.north = L.new(:name => "North West Room")
    main
  end
  def greeting
    # Yes, I compressed the string. Deal with it.
    base64_zlib_inflate "eJydUdEKACEIe/crhP3/Px6V2XJyByeEpmsuNccw9/Qj8mX7euqwlYSnz5hS0yuU6kptogQkybfhMJ/+wowe+ikCZkUHf6OUTNo0oMl4payo/H934Y/dpZjI8275eQwPccqk4jsy0wEm0nuwhN/NuS7r7fgL/trxC77rB3sAsstclA=="
  end  
end
