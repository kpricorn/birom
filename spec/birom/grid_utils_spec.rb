require 'spec_helper'

require 'birom/grid'
require 'birom/triangle'
require 'birom/grid_utils'

module Birom
  describe GridUtils do

    describe '#copyGrid' do
      context 'with 1 triangle' do
        let(:t0) { Triangle.new(0, 0, 0, Triangle::TRI_TYPE_COUNTER) }
        let(:orig) { g = Grid.new(); g.set(t0); g }
        let(:copy) { GridUtils.copyGrid(orig) }

        it 'returns equal triangles' do
          orig.get(0, 0, 0).should_not be(copy.get(0, 0, 0))
        end

        it 'copies triangles' do
          orig.get(0, 0, 0).should == copy.get(0, 0, 0)
        end
      end
    end

  end
end
