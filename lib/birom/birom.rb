require 'birom/triangle'
require 'birom/counter'

module Birom

  class Birom

    include Counter

    PLAYER_ID_UNDEFINED = 0
    TRI_TYPE_COUNTER = 0

    def initialize(coordinates, playerId = PLAYER_ID_UNDEFINED, type = TRI_TYPE_COUNTER)
      @playerId = playerId
      @type = type

      unless coordinates.is_a? Array then
        raise Exception('Coordinates is not an array')
      end

      if coordinates.length != 4 then
        raise Exception('Number of coordinates does not match')
      end

      @triangles = coordinates.map do |c|
        Triangle.new(c[:u], c[:v], c[:w], @type, @playerId)
      end

      @triangles.each do |t|
        combos = [t].product(@triangles - [t])
        combos.each do |t1, t2|
          if  (t1.u - t2.u).abs > 1 or
              (t1.v - t2.v).abs > 1 or
              (t1.w - t2.w).abs > 1 then
            raise Exception('Not a birom')
          end
        end

        close_neighbour_count_of_t = combos.map do |t1, t2|
          t1.isCloseNeighbour t2
        end.count(true)

        unless (1..2).member?(close_neighbour_count_of_t)
          raise Exception('Not a birom')
        end
      end

      unless @triangles.combination(2).map do |t1, t2|
        t1.isCloseNeighbour(t2)
      end.count(true) == 3
        raise Exception('Not a birom')
      end
    end

  end
end
