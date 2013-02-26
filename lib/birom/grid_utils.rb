require 'birom/grid'
require 'birom/triangle'

module Birom
  class GridUtils
    def self.copyGrid(grid)
      copy = {}
      grid.triangles.select do |key, t|
        t.type != Triangle::TRI_TYPE_BORDER
      end.each do |key, t|
        copy[key] = Triangle.new(t.u, t.v, t.w, t.type, t.playerId)
      end
      Grid.new(copy)
    end
  end
end
