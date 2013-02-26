module Birom
  module Counter

    attr_accessor :triangles

    def getVertices
      vertices = []
      @triangles.each do |t|
        t.getVertices.each do |v|
          unless vertices.any? { |_v| v[:x] == _v[:x] and v[:y] == _v[:y] } then
            vertices << v
          end
        end
      end
      vertices
    end

    def connected?(neighbours)
      moveVerts = Set.new(getVertices)
      nbVerts = Set.new(neighbours.map do |nb|
        nb.getVertices
      end.flatten)

      (moveVerts & nbVerts).count > 1
    end

  end
end
