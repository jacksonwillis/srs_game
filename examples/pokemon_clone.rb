require "srs_game"
include SRSGame

module PokemonClone
  def greeting
    "      /\"*-.\n" << \
    "     /     `-.\n" << \
    "    /         `-.\n" << \
    "   /             `-.\n" << \
    "   `\"*-._           `-.\n" << \
    "         \"*-.      .-'\n" << \
    "           .-'  .-'\n" << \
    "         <'   <'\n" << \
    "          `-.  `-.           .\n" << \
    "            .'  .-'          $\n" << \
    "     _    .' .-'     bug    :$;\n" << \
    "     T$bp.L.-*\"\"*-._        d$b\n" << \
    "      `TP `-.       `-.    : T$\n" << \
    "     .' `.   `.        `.  ;  ;\n" << \
    "    /     `.   \\ _.      \\:  :\n" << \
    "   /        `..-\"         ;  |\n" << \
    "  :          /               ;\n" << \
    "  ;  \\      / _             :\n" << \
    " /`--'\\   .' $o$            |\n" << \
    "/  /   `./-, `\"'      _     :\n" << \
    "'-'     :  ;  _ '    $o$    ;\n" << \
    "        ;Y\"   |\"-.   `\"'   /\n" << \
    "        | `.  L.'    .-.  /`*.\n" << \
    "        :   `-.     ;   :'    \\\n" << \
    "         ;    :`*-._L.-'`-.    :\n" << \
    "         :    ;            `-.*\n" << \
    "          \\  /\n" << \
    "           \"\" ~* PokemonClone.rb *~"
  end

  def main_room
    main = L.new(:name => "outside your house")
    main.down = L.new(:name => "in your house")
    main.north = L.new(:name => "")
    main
  end

  class Commands; class << self

  end; end
end

SRSGame.play PokemonClone
