module Birom
  class TurnUndefined; end
  class Game

    attr_reader :red
    attr_reader :grid
    attr_reader :running
    attr_reader :moves
    attr_reader :players
    attr_reader :turn
    attr_reader :winners

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
      @winners = []
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

    def opponents(player)
      @players.keep_if
      @players.reject do |p|
        p == player
      end
    end

    def take(turn)
      unless @running
        raise Exception.new("Game is not running")
      end

      if @turn != turn.gamePlayer
        raise Exception.new("Not player's turn")
      end

      counter = turn.counter
      points = []
      gridCopy = GridUtils.copyGrid(@grid)

      gridCopy.validate!(counter)
      counter.triangles.each do |triangle|
        gridCopy.set(triangle)
      end
      gridCopy.fillBorderTriangles

      gridCopy.getPointTriangles(counter).each do |pointTriangle|
        gridCopy.set pointTriangle
        points << pointTriangle
      end

      turn.gamePlayer.points += points.length
      captured = gridCopy.getCapturedTriangles(turn.counter.triangles)

      pcMap = {}
      # TODO: duplicated triangles are returned
      captured = gridCopy.getCapturedTriangles(turn.counter.triangles)
      captured.each do |t|
        unless t.player.nil?
          pcMap[t.player] ||= []
          pcMap[t.player] << "#{t.u}/#{t.v}/#{t.w}"
        end
        t.type = Triangle::TRI_TYPE_COMMON
        t.player = nil
        gridCopy.set(t)
      end

      # increment opponent's counter (captured triangles)
      pcMap.each do |player, coords|
        opponents(player).each do |opponent|
            opponent.countersLeft += coords.uniq.length / 4
        end
      end

      # decrement current move
      turn.gamePlayer.countersLeft -= 1

      @turn = Game.getNextTurn(@turn, @players)

      if @turn.nil?
        @running = false
      end

      @winners.push(*@players.select do |player|
        gridCopy.isEncircledBy(@red.triangles.first, player)
      end)

      @running = @winners.empty?

      @grid = GridUtils.copyGrid(gridCopy)
      turn
    end

    def self.getNextTurn(currentPlayer, players)
      pidx = players.index(currentPlayer)
      players.rotate(pidx + 1).select do |player|
        player.countersLeft > 0
      end.first
    end
  end
end
