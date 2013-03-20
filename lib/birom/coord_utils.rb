module Birom
  SR3 = Math.sqrt 3
  PI30 = Math::PI / 6
  PI60 = Math::PI / 3
  SIN30 = Math.sin PI30
  COS30 = Math.cos PI30
  SIN60 = Math.sin PI60
  COS60 = Math.cos PI60

  class CoordUtils
    def self.vector_to_triangles u, v, orientation
      coords = [u, v, - u - v]
      projection = [
        [0 ,  1 , -1],
        [0 ,  1 ,  0],
        [0 ,  0 ,  0],
        [1 ,  0 ,  0],
        [1 ,  0 , -1],
        [1 ,  1 , -1],
      ]
      # int division by 60 and remove 2 triangles
      # offset
      steps = orientation / 60 % 6 - 2
      projection.rotate(steps)[0...4].map do |p|
        [coords, p].transpose.map {|x| x.reduce(:+)}
      end
    end
  end
end
