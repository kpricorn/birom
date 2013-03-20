require 'spec_helper'

require 'birom/coord_utils'

module Birom
  describe CoordUtils do

    describe '#vector_to_triangles' do
      it 'converts 0/0 and 0' do
        CoordUtils.vector_to_triangles(0, 0, 0).should == [
          [1, 0, -1],
          [1, 1, -1],
          [0, 1, -1],
          [0, 1,  0],
        ]
      end

      it 'converts 0/0 and 120' do
        CoordUtils.vector_to_triangles(0, 0, 120).should == [
          [0, 1, -1],
          [0, 1,  0],
          [0, 0,  0],
          [1, 0,  0],
        ]
      end

      it 'converts -4/2 and 300' do
        CoordUtils.vector_to_triangles(-4, 2, 300).should == [
          [-3, 2, 2],
          [-3, 2, 1],
          [-3, 3, 1],
          [-4, 3, 1],
        ]
      end
    end
  end
end
