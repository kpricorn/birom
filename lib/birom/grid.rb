module Birom
  class Grid

    attr_accessor :triangles

    def initialize(triangles = {})
      @triangles = triangles
    end

    def set(triangle)
      unless triangle.is_a? Triangle
        raise Exception.new("Argument is not a triangle")
      end
      @triangles["#{triangle}"] = triangle
    end

    def get(u, v, w)
      @triangles["#{u}/#{v}/#{w}"]
    end

    def getNeighbours(tri)
      tri.getNeighbourCoords.map do |neighbours|
        get(neighbours[:u], neighbours[:v], neighbours[:w])
      end.compact
    end

    def getCloseNeighbours(tri)
      tri.getCloseNeighbourCoords.map do |neighbours|
        get(neighbours[:u], neighbours[:v], neighbours[:w])
      end.compact
    end

    # o: triangle   +---∆-----B
    #              /   ∆∆∆   /
    #             ∆∆∆∆∆∆    /
    #            /    ∆∆∆∆∆∆
    #           A------∆--+
    # returns the coordinates [ A, B ]
    def getBoundingBox
      if @triangles.empty?
        [
          {u: 0, v: 0, w: 0},
          {u: 0, v: 0, w: 0},
        ]
      else
        us = @triangles.values.map(&:u)
        vs = @triangles.values.map(&:v)
        [
          {u: maxU = us.max, v: maxV = vs.max, w: -maxU - maxV},
          {u: minU = us.min, v: minV = vs.min, w: 1 - minU - minV}
        ]
      end
    end

    def deepCopy
      copy = {}
      @triangles.select do |key, t|
        t.type != Triangle::TRI_TYPE_BORDER
      end.each do |key, t|
        copy[key] = Triangle.new(t.u, t.v, t.w, t.type, t.playerId)
      end
      Grid.new(copy)
    end
  end
end
