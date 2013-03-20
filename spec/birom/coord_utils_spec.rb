require 'spec_helper'

require 'birom/coord_utils'

module Birom
  describe CoordUtils do

    describe '#vector_to_triangles' do
      it 'converts 0/0 and 0' do
        CoordUtils.vector_to_triangles(0, 0, 0).should == [
          {u: 1, v: 0, w: -1},
          {u: 1, v: 1, w: -1},
          {u: 0, v: 1, w: -1},
          {u: 0, v: 1, w:  0},
        ]
      end

      it 'converts 0/0 and 120' do
        CoordUtils.vector_to_triangles(0, 0, 120).should == [
          {u: 0, v: 1, w: -1},
          {u: 0, v: 1, w:  0},
          {u: 0, v: 0, w:  0},
          {u: 1, v: 0, w:  0},
        ]
      end

      it 'converts -4/2 and 300' do
        CoordUtils.vector_to_triangles(-4, 2, 300).should == [
          {u: -3, v: 2, w: 2},
          {u: -3, v: 2, w: 1},
          {u: -3, v: 3, w: 1},
          {u: -4, v: 3, w: 1},
        ]
      end
    end
  end
end
