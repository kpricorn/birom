require 'birom/birom'
require 'birom/grid'
require 'birom/grid_utils'
require 'birom/game_player'

module Birom
  class TurnUndefined; end
  class Game

    attr_reader :red
    attr_reader :grid
    attr_reader :running
    attr_reader :moves
    attr_reader :players
    attr_reader :turn

    def initialize
      @red = Birom::RED
      @grid = Grid.new
      @red.triangles.each do |t|
        @grid.set t
      end
      @players = []
      @running = false
      @numberOfPlayers = 2
      @turn = TurnUndefined
      @moves = [@red]
    end

    def join(user)
      if @running
        raise Exception.new('Game already running')
      end

      gamePlayer = GamePlayer.new
      if players.empty?
        gamePlayer.id = 0
        @turn = gamePlayer
      else
        gamePlayer.id = @players.map(&:id).max + 1
      end

      @players << gamePlayer

      if @players.count >= @numberOfPlayers
        @running = true
      end

      gamePlayer
    end

  end
end
