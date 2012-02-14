class String
  SRS_ANSI_COLORS = {
          clear: 0 ,
          reset: 0 ,
           bold: 1 ,
           dark: 2 ,
         italic: 3 ,
      underline: 4 ,
     underscore: 4 ,
          blink: 5 ,
    rapid_blink: 6 ,
       negative: 7 ,
      concealed: 8 ,
  strikethrough: 9 ,
          black: 30,
            red: 31,
          green: 32,
         yellow: 33,
           blue: 34,
        magenta: 35,
           cyan: 36,
          white: 37,
       on_black: 40,
         on_red: 41,
       on_green: 42,
      on_yellow: 43,
        on_blue: 44,
     on_magenta: 45,
        on_cyan: 46,
       on_white: 47,
  }

  def ansi(code)
    "\e[#{SRS_ANSI_COLORS[code]}m#{self}\e[0m"
  end
end
