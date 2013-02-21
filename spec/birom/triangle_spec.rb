require 'spec_helper'
require 'birom/triangle'

module Birom
  describe Triangle do
    describe '#initialize' do

      context 'with coordinates 0/1/0' do
        it 'returns matching triangle' do
          Triangle.new(0, 1, 0).should have_same_coordinates({u: 0, v: 1, w: 0})
        end
      end

      context 'with coordinates 0/0/0' do
        it 'returns matching triangle' do
          Triangle.new(0, 0, 0).should have_same_coordinates({u: 0, v: 0, w: 0})
        end
      end

      context 'with coordinates -1/1/0' do
        it 'returns matching triangle' do
          Triangle.new(-1, 1, 0).should have_same_coordinates({u: -1, v: 1, w: 0})
        end
      end

      context 'without constructor arguments' do
        it 'raises' do
          expect{Triangle.new}.to raise_error
        end
      end

      context 'with invalid constructor arguments' do
        it 'raises' do
          expect{Triangle.new('foo', 1, 0)}.to raise_error
        end
      end

      context 'with missing constructor arguments' do
        it 'raises' do
          expect{Triangle.new(1, 0)}.to raise_error
        end
      end

      context 'with invalid coordinates' do
        it 'raises' do
          expect{Triangle.new(1, 0, 1, 1)}.to raise_error
        end

        it 'raises' do
          expect{Triangle.new(1, 1, 0)}.to raise_error
        end
      end
    end

    describe '#isFacingUp' do
      context 'with coordinates 0/0/0' do
        it 'faces up' do
          Triangle.new(0, 0, 0).isFacingUp.should be_true
        end
      end

      context 'with coordinates 0/1/0' do
        it 'faces down' do
          Triangle.new(0, 1, 0).isFacingUp.should be_false
        end
      end
    end
    describe '#isCloseNeighbour' do
      let(:t1) { Triangle.new(0, 0, 0) }
      let(:t2) { Triangle.new(0, 1, 0) }
      let(:t3) { Triangle.new(1, -1, 1) }

      context 'with 0/0/0 and 0/1/0' do
        it 'should return true' do
          t1.isCloseNeighbour(t2).should be_true
        end
      end

      context 'with 0/0/0 and 1/-1/1' do
        it 'should return false' do
          t1.isCloseNeighbour(t3).should be_false
        end
      end
    end
    describe '#getNeighbourCoords' do
      context 'with 0, 0, 0' do
        let(:t) { Triangle.new(0, 0, 0) }
        let(:n) { 
          [
            { u: -1, v: 1, w: 1 },
            { u: -1, v: 0, w: 1 },
            { u: 0, v: 0, w: 1 },
            { u: 0, v: -1, w: 1 },
            { u: 1, v: -1, w: 1 },
            { u: 1, v: -1, w: 0 },
            { u: 1, v: 0, w: 0 },
            { u: 1, v: 0, w: -1 },
            { u: 1, v: 1, w: -1 },
            { u: 0, v: 1, w: -1 },
            { u: 0, v: 1, w: 0 },
            { u: -1, v: 1, w: 0 },
          ]
        }

        it 'returns 12 neighbour coordinates' do
          t.getNeighbourCoords.count.should == 12
        end

        it 'returns neighbour coordinates' do
          t.getNeighbourCoords.should be_matching_coordinates(n)
        end
      end
    end

    describe '#getCloseNeighbourCoords' do
      context 'with 0, 0, 0' do
        let(:t) { Triangle.new(0, 0, 0) }
        let(:n) { 
          [
            {u: 1, v: 0, w: 0},
            {u: 0, v: 1, w: 0},
            {u: 0, v: 0, w: 1},
          ]
        }

        it 'returns 3 close neighbour coordinates' do
          t.getCloseNeighbourCoords.count.should == 3
        end

        it 'returns close neighbour coordinates' do
          t.getCloseNeighbourCoords.should be_matching_coordinates(n)
        end
      end

      context 'with 1, 0, 0' do
        let(:t) { Triangle.new(1, 0, 0) }
        let(:n) { 
          [
            {u: 1, v: -1, w: 0},
            {u: 0, v: 0, w: 0},
            {u: 1, v: 0, w: -1},
          ]
        }

        it 'returns 3 close neighbour coordinates' do
          t.getCloseNeighbourCoords.count.should == 3
        end

        it 'returns close neighbour coordinates' do
          t.getCloseNeighbourCoords.should be_matching_coordinates(n)
        end
      end
    end
    describe '#getVertices' do
      context 'with 0, 0, 0' do
        let(:t) { Triangle.new(0, 0, 0) }
        let(:n) { 
          [
            {x: 0, y: 0},
            {x: -1, y: 0},
            {x: 0, y: -1},
          ]
        }

        it 'returns vertex x/y coordinates' do
          t.getVertices.should be_matching_coordinates(n)
        end
      end
      context 'with 1, 0, 0' do
        let(:t) { Triangle.new(1, 0, 0) }
        let(:n) { 
          [
            {x: 0, y: -1},
            {x: -1, y: 0},
            {x: -1, y: -1},
          ]
        }

        it 'returns vertex x/y coordinates' do
          t.getVertices.should be_matching_coordinates(n)
        end
      end
    end
  end
end
