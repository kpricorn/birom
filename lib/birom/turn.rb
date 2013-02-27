module Birom
  class Turn
    attr_reader :gamePlayer
    attr_reader :counter

    attr_accessor :points

    def initialize(gamePlayer, counter)
      @gamePlayer = gamePlayer
      @counter = counter
    end
  end
end
