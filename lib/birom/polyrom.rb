require 'birom/triangle'
require 'birom/counter'

module Birom

  class Polyrom

    include Counter

    PLAYER_ID_UNDEFINED = 0
    TRI_TYPE_COUNTER = 0

    def initialize(coordinates, playerId = PLAYER_ID_UNDEFINED, type = TRI_TYPE_COUNTER)
      @playerId = playerId
      @type = type

      unless coordinates.is_a? Array then
        raise Exception('Coordinates is not an array')
      end

      @triangles = coordinates.map do |c|
        Triangle.new(c[:u], c[:v], c[:w], @type, @playerId)
      end
    end

  end
end
