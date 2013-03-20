module Birom

  module BiromCommon
    attr_accessor :turn
  end

  class VectorBirom

    attr_accessor :u
    attr_accessor :v
    attr_accessor :rotation

    include Counter
    include BiromCommon

    def initialize(u, v, rotation, turn = nil)

      unless u.is_a? Numeric or v.is_a? Numeric or rotation.is_a? Numeric
        raise Exception.new('Arguments u, v and rotation need to be numbers')
      end

      unless turn.nil? and not turn.is_a? Turn
        raise Exception.new('Arguments turn needs to be instance of Turn')
      end

      @u = u
      @v = v
      @rotation = rotation
      @turn = turn
    end

    def triangles
      CoordUtils.vector_to_triangles(u, v, rotation).map do |tCords|
        Triangle.new(
          tCords[:u],
          tCords[:v],
          tCords[:w]
        )
      end
    end
  end

  class Birom

    include Counter

    PLAYER_ID_UNDEFINED = UndefinedPlayer.new

    def self.new_from_uv_and_rotation(u, v, rotation, *args)
      triangles = CoordUtils.vector_to_triangles(u, v, rotation)
      Birom.new(triangles, *args)
    end

    def initialize(coordinates,
                   player = PLAYER_ID_UNDEFINED,
                   type = Triangle::TRI_TYPE_COUNTER)
      @player = player
      @type = type

      unless coordinates.is_a? Array
        raise Exception.new('Coordinates is not an array')
      end

      if coordinates.length != 4
        raise Exception.new('Number of coordinates does not match')
      end

      @triangles = coordinates.map do |c|
        Triangle.new(c[:u], c[:v], c[:w], @type, @player)
      end

      unless valid?
        raise Exception.new('Not a birom')
      end
    end

    def valid?
      @triangles.each do |t|
        combos = [t].product(@triangles - [t])
        combos.each do |t1, t2|
          if  (t1.u - t2.u).abs > 1 or
              (t1.v - t2.v).abs > 1 or
              (t1.w - t2.w).abs > 1
            return false
          end
        end

        close_neighbour_count_of_t = combos.map do |t1, t2|
          t1.isCloseNeighbour t2
        end.count(true)

        unless (1..2).member?(close_neighbour_count_of_t)
          return false
        end
      end

      unless @triangles.combination(2).map do |t1, t2|
        t1.isCloseNeighbour(t2)
      end.count(true) == 3
        return false
      end
      true
    end

    RED = Birom.new(
      [
        { u: 0, v: 0, w: 0 },
        { u: 0, v: 1, w: 0 },
        { u: -1, v: 1, w: 0 },
        { u: -1, v: 1, w: 1 }
      ], Birom::PLAYER_ID_UNDEFINED, Triangle::TRI_TYPE_START
    )
  end
end
