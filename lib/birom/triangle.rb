module Birom

  class Triangle

    attr_accessor :u
    attr_accessor :v
    attr_accessor :w
    attr_accessor :type
    attr_accessor :playerId

    TRI_TYPE_UNDEFINED = 0
    PLAYER_ID_UNDEFINED = 0

    def initialize(u, v, w, type = TRI_TYPE_UNDEFINED, playerId = PLAYER_ID_UNDEFINED)
      unless ([u, v, w].all? {|c| c.is_a? Integer }) then
        raise Exception.new('Invalid or missing coordinates')
      end

      unless (0..1).member?(u + v + w) then
        raise Exception.new("Invalid coordinates")
      end

      @u = u
      @v = v
      @w = w
      @type = type
      @playerId = playerId

    end

    def to_s
      "#{@u}/#{@v}/#{@w}"
    end

    def isFacingUp
      (@u + @v + @w) == 0
    end

    def isCloseNeighbour(tri)
      (@u - tri.u).abs + (@v - tri.v).abs + (@w - tri.w).abs == 1
    end

    def getNeighbourCoords
      cords = []
      ( @u - 1..@u + 1 ).each do |_u|
        ( @v - 1..@v + 1 ).each do |_v|
          ( @w - 1..@w + 1 ).each do |_w|
            cords << { u: _u, v: _v, w: _w }
          end
        end
      end
      cords.select do |c|
        (0..1).member?(c[:u] + c[:v] + c[:w]) and not
          (c[:u] == @u and c[:v] == @v and c[:w] == @w)
      end
    end

    def getCloseNeighbourCoords
      offset = self.isFacingUp ? 1 : -1
      [
        {u: @u + offset, v: @v, w: @w},
        {u: @u, v: @v + offset, w: @w},
        {u: @u, v: @v, w: @w + offset}
      ]
    end

    def getVertices
      if self.isFacingUp then
        [
          {x: @v, y: @w},           # A     A
          {x: @v - 1, y: @w},       # B    / \
          {x: @v, y: @w - 1}        # C   C---B
        ]
      else
        [
          {x: @v, y: @w - 1},       # A   A---B
          {x: @v - 1, y: @w},       # B    \ /
          {x: @v - 1, y: @w - 1}    # C     C
        ]
      end
    end
  end
end
