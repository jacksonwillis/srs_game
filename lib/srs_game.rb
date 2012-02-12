module SRSGame
  class << self
    def play(middleware, env)
      raise "No middleware for SRSGame.play" unless middleware
      middleware.play
    end
  end
end
