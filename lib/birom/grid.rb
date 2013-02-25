require 'birom/common'
require 'birom/triangle'

module Birom
  class BorderReached < Exception; end
  class EndOfBranch < Exception; end
  class SlotFound < Exception; end

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
    #             ∆∆∆∆∆∆    / # look mom, alt-j's on stage ;)
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

    def fillBorderTriangles
      a, o = getBoundingBox
      ta = Triangle.new(a[:u] + 1, a[:v] + 1, a[:w] - 2, Triangle::TRI_TYPE_BORDER)
      to = Triangle.new(o[:u] - 1, o[:v] - 1, o[:w] + 2, Triangle::TRI_TYPE_BORDER)
      # two callbacks mark and neighbours
      # mark start coordinate as visited
      set ta
      Common.bfs ta do |t|
        # find neighbours of t
        # include:
        # - coordinates within bounding box
        # - vacant coordinates
        # return valid triangles (type: border)
        neighbours = []
        t.getCloseNeighbourCoords.each do |neighbour|
          tn = Triangle.new(neighbour[:u],
                           neighbour[:v],
                           neighbour[:w],
                           Triangle::TRI_TYPE_BORDER)
          if Common::isWithin(ta, to, tn) and
            get(neighbour[:u], neighbour[:v], neighbour[:w]).nil? then
            # mark as visited (adding to the grid)
            set tn
            neighbours << tn
          end
        end
        neighbours
      end
    end

    def getPointTriangles(currentMove)
      unless currentMove.is_a? Array
        raise Exception.new("Argument is not an array")
      end
      # mark visited nodes
      marked = []
      pointTriangles = []
      # start walk with arbitrary triangle of currentMove
      root = currentMove.first
      Common.bfs root do |t|
        # find neighbours (ENB) of t including:
        # - vacant coordinates (undefined on grid)
        # - currentMove
        nbCoords = t.getCloseNeighbourCoords.select do |c|
          (
            get(c[:u], c[:v], c[:w]).nil? or currentMove.include? c
          ) and not marked.include? c
        end
        # return valid triangles (type: border)
        neighbours = nbCoords.map do |c|
          marked << c
          nb = get(c[:u], c[:v], c[:w])
          if nb.nil?
            nb = Triangle.new(c[:u], c[:v], c[:w],
                              Triangle::TRI_TYPE_POINT, root.playerId)
            pointTriangles << nb
          end
          nb
        end
        neighbours
      end
      pointTriangles
    end

    def isEncircledBy(redBiromTriangle, playerId)
      marked = []
      unless redBiromTriangle.type == Triangle::TRI_TYPE_START
        raise Exception.new("Argument is not a red birom triangle")
      end
      encircled = true

      begin
        Common.bfs redBiromTriangle do |t|
          neighbours = []
          getCloseNeighbours(t).each do |c|
            if c.type == Triangle::TRI_TYPE_BORDER
              raise BorderReached.new
            end
            if c.type == Triangle::TRI_TYPE_START or
              (
                c.type == Triangle::TRI_TYPE_COUNTER and
                c.playerId.to_i != playerId.to_i
              )and not marked.include? c
              neighbours << c
            end
            marked << c
          end
          neighbours
        end
      rescue BorderReached
        encircled = false
      end
      encircled
    end

    def getCapturedTriangles(currentMove)
      unless currentMove.is_a? Array
        raise Exception.new("Argument is not an array")
      end

      # mark visited nodes
      marked = []

      # outer bfs:
      # Walk from current move along newly won point stones until a triangle
      # of type POINT
      # inner bfs:
      # From there a nested bfs is started to determine
      # if the chain is fully encircled and therefore captured.
      #
      # start walk with arbitrary triangle of currentMove
      root = currentMove.first
      branches = []

      Common.bfs root do |t|
        # find neighbours (ENB) of t including:
        # - currentMove
        # - point triangles with same playerId
        cNbs = getCloseNeighbours(t)
        nbs = []
        cNbs.each do |c|
          if (
            (
              c.type == Triangle::TRI_TYPE_POINT and
              c.playerId == root.playerId
            ) or currentMove.include? c
          ) and not marked.include? c
            # mark as visited
            marked << c
            nbs << c
          end
        end

        # start inner bfs
        branchNodes = cNbs.select do |c|
          c.type == Triangle::TRI_TYPE_COUNTER and not marked.include? c
        end

        branchNodes.each do |branchRoot|
          # mark as visited
          marked << branchRoot
          branches << getCapturedBranch(branchRoot)
        end

        ## end inner bfs
        nbs
      end

      return branches.flatten
    end

    def findSnappingSlots(move)
      unless move.is_a? Array
        raise Exception.new("Argument is not an array")
      end

      start = move.first
      marked = []
      slot = []
      neighbourProjections = [
        { u: -1, v:  1, w:  0 },
        { u:  1, v:  0, w: -1 },
        { u:  0, v: -1, w:  1 },
        { u:  1, v: -1, w:  0 },
        { u:  1, v:  0, w: -1 },
        { u:  0, v:  1, w: -1 },
      ]

      # note: internal calculation done with Triangle, not hash
      begin
        Common.bfs start do |node|
          marked << node

          testSlotProjection = Triangle.new(
            node.u - start.u, node.v - start.v, node.w - start.w
          )

          moveProjection = move.map do |t|
            Triangle.new(
              t.u + testSlotProjection.u,
              t.v + testSlotProjection.v,
              t.w + testSlotProjection.w,
            )
          end

          slotTest = moveProjection.map do |t|
            get(t.u, t.v, t.w).nil?
          end

          if slotTest.all?
            slot = moveProjection
            raise SlotFound.new
          end

          neighbours = neighbourProjections.map do |p|
            Triangle.new(
              node.u + p[:u],
              node.v + p[:v],
              node.w + p[:w]
            )
          end

          neighbours.reject do |nb|
            marked.include? nb
          end
        end
      rescue SlotFound
      end
      # convert back to u/v/w hash
      slot.map do |t|
        {
          u: t.u,
          v: t.v,
          w: t.w
        }
      end
    end

    private
    def getCapturedBranch(branchRoot)
      marked = [branchRoot]
      branch = []
      begin
        Common.bfs branchRoot do |t|
          branch << t
          nbs = getCloseNeighbours(t)
          validNbs = []
          nbs.each do |c|
            if c.type == Triangle::TRI_TYPE_BORDER
              raise EndOfBranch.new
            end
            if (
              c.type == Triangle::TRI_TYPE_COUNTER and
              c.playerId == t.playerId
            ) and not marked.include? c
              validNbs << c
              marked << c
            end
          end
          validNbs
        end
      rescue EndOfBranch
        branch = []
      end
      branch
    end
  end
end
