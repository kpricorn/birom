module Birom
  class GamePlayer

    attr_accessor :id
    attr_accessor :points
    attr_accessor :countersLeft
    attr_accessor :user

    def initialize
      @points = 0
      @countersLeft = 15
    end

  end
end
