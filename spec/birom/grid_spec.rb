require 'spec_helper'

require 'birom/grid'
require 'birom/polyrom'
require 'birom/triangle'

module Birom
  describe Grid do
    describe '#initialize' do
      it 'can be initialized' do
        Grid.new.should be_an_instance_of(Grid)
      end
    end

    describe '#set' do
      let(:grid) { Grid.new }

      context 'without triangle' do
        it 'raises' do
          expect{grid.set}.to raise_error
        end
      end

      context 'with invalid triangle' do
        it 'raises' do
          expect{grid.set('foo')}.to raise_error
        end
      end

      context 'with valid triangle' do
        let(:triangle) { Triangle.new(0, 0, 0) }
        it 'stores triangle' do
          grid.set(triangle)
          grid.triangles.count.should == 1
        end
      end
    end

    describe '#get' do
      context 'with stored triangle' do
        let(:triangle) { Triangle.new(0, 0, 0) }
        let(:grid) do
          g = Grid.new
          g.set(triangle)
          g
        end

        it 'stores triangle' do
          grid.get(0, 0, 0).should be(triangle)
        end
      end
    end

    describe '#getNeighbours' do
      context 'for triangle 0/0/0' do
        let(:triangle) { Triangle.new(0, 0, 0) }

        let(:grid) do
          g = Grid.new
          g.set(triangle)
          g
        end

        context 'with only one stored triangle' do
          it 'returns an empty array' do
            grid.getNeighbours(triangle).should == []
          end
        end

        context 'with 3 neighbours' do

          let(:triangles) do
            [
              Triangle.new(1, 0, 0),
              Triangle.new(0, 1, 0),
              Triangle.new(0, 0, 1),
              Triangle.new(0, -1, 2),
            ]
          end

          let(:grid) do
            g = Grid.new
            g.set(triangle)
            triangles.each { |t| g.set(t) }
            g
          end

          it 'returns 3 neighbours' do
            grid.getNeighbours(triangle).should =~ triangles[0..2]
          end
        end
      end
    end

    describe '#getCloseNeighbours' do
      context 'for triangle 0/0/0' do
        let(:triangle) { Triangle.new(0, 0, 0) }

        let(:grid) do
          g = Grid.new
          g.set(triangle)
          g
        end

        context 'with only one stored triangle' do
          it 'returns an empty array' do
            grid.getCloseNeighbours(triangle).should == []
          end
        end

        context 'with 3 neighbours' do

          let(:triangles) do
            [
              Triangle.new(1, 0, 0),
              Triangle.new(0, 1, 0),
              Triangle.new(0, 0, 1),
              Triangle.new(0, -1, 2),
            ]
          end

          let(:grid) do
            g = Grid.new
            g.set(triangle)
            triangles.each { |t| g.set(t) }
            g
          end

          it 'returns 3 neighbours' do
            grid.getCloseNeighbours(triangle).should =~ triangles[0..2]
          end
        end
      end
    end

    describe '#getBoundingBox' do
      let(:grid) { Grid.new }

      context 'with empty grid' do
        it 'returns 0/0/0, 0/0/0' do
          grid.getBoundingBox.should == [
            { u: 0, v: 0, w: 0 },
            { u: 0, v: 0, w: 0 }
          ]
        end
      end

      context 'with 3 triangles' do
        it 'returns A/B' do
          grid.set Triangle.new(0, 0, 0)
          grid.set Triangle.new(1, 0, 0)
          grid.set Triangle.new(0, 1, 0)

          grid.getBoundingBox.should == [
            { u: 1, v: 1, w: -2 },
            { u: 0, v: 0, w: 1 }
          ]
        end
      end
    end

    describe '#fillBorderTriangles' do
      context 'with single birom' do
        let(:grid) do
          g = Grid.new()
          # fill grid with red birom
          g.set Triangle.new(0, 0, 0, nil, Triangle::TRI_TYPE_START)
          g.set Triangle.new(0, 1, 0, nil, Triangle::TRI_TYPE_START)
          g.set Triangle.new(-1, 1, 0, nil, Triangle::TRI_TYPE_START)
          g.set Triangle.new(-1, 1, 1, nil, Triangle::TRI_TYPE_START)
          g
        end

        let(:expected) do
          [
            Triangle.new(0, 0, 0),
            Triangle.new(0, 1, 0),
            Triangle.new(-1, 1, 0),
            Triangle.new(-1, 1, 1),
            Triangle.new(1, 2, -3),
            Triangle.new(1, 2, -2),
            Triangle.new(0, 2, -2),
            Triangle.new(1, 1, -2),
            Triangle.new(0, 2, -1),
            Triangle.new(1, 1, -1),
            Triangle.new(-1, 2, -1),
            Triangle.new(0, 1, -1),
            Triangle.new(1, 0, -1),
            Triangle.new(-1, 2, 0),
            Triangle.new(1, 0, 0),
            Triangle.new(-2, 2, 0),
            Triangle.new(1, -1, 0),
            Triangle.new(-2, 2, 1),
            Triangle.new(1, -1, 1),
            Triangle.new(-2, 1, 1),
            Triangle.new(0, -1, 1),
            Triangle.new(-2, 1, 2),
            Triangle.new(0, 0, 1),
            Triangle.new(0, -1, 2),
            Triangle.new(-2, 0, 2),
            Triangle.new(-1, 0, 1),
            Triangle.new(-1, -1, 2),
            Triangle.new(-1, 0, 2),
            Triangle.new(-2, 0, 3),
            Triangle.new(-1, -1, 3),
            Triangle.new(-2, -1, 3),
            Triangle.new(-2, -1, 4)
          ]
        end

        it 'fills empty space with border triangles' do
          grid.fillBorderTriangles
          grid.triangles.values.should be_matching_coordinates(expected)
        end
      end

      context '0/0/0 with 3 orbiting counters' do
        let(:grid) do
          g = Grid.new
          g.set Triangle.new(1, 0, 0, Triangle::TRI_TYPE_COUNTER)
          g.set Triangle.new(0, 1, 0, Triangle::TRI_TYPE_COUNTER)
          g.set Triangle.new(0, 0, 1, Triangle::TRI_TYPE_COUNTER)
          g.fillBorderTriangles
          g
        end

        it 'keeps 0/0/0 empty after flooding' do
          grid.get(0, 0, 0).should be_nil
        end
      end
    end

    describe '#getPointTriangles' do
      context '0/0/0 with 3 orbiting counters' do
        let(:points) do
          g = Grid.new
          g.set Triangle.new(1, 0, 0, Triangle::TRI_TYPE_COUNTER, 99)
          g.set Triangle.new(0, 1, 0, Triangle::TRI_TYPE_COUNTER, 99)
          g.set Triangle.new(0, 0, 1, Triangle::TRI_TYPE_COUNTER, 99)
          g.fillBorderTriangles
          g.getPointTriangles(Polyrom.new([{
            u: 0, v: 0, w: 1}], 99, Triangle::TRI_TYPE_COUNTER
          ))
        end

        it 'returns 0/0/0 as point triangle' do
          points.should == [Triangle.new(0, 0, 0)]
          points[0].playerId.should == 99
          points[0].type.should == Triangle::TRI_TYPE_POINT
        end
      end
    end

    describe '#isEncircledBy' do

      let(:red) { Triangle.new 0, 0, 0, Triangle::TRI_TYPE_START }

      context 'when red birom is surrounded by 99' do
        let(:grid) do
          g = Grid.new
          g.set red
          g.set Triangle.new 1, 0, 0, Triangle::TRI_TYPE_COUNTER, 99
          g.set Triangle.new 0, 1, 0, Triangle::TRI_TYPE_COUNTER, 99
          g.set Triangle.new 0, 0, 1, Triangle::TRI_TYPE_COUNTER, 99
          g.fillBorderTriangles()
          g
        end

        it 'returns false for 11' do
          grid.isEncircledBy(red, 11).should be_false
        end

        it 'returns true for 99' do
          grid.isEncircledBy(red, 99).should be_true
        end
      end

      context 'when red birom is not surrounded' do
        let(:grid) do
          g = Grid.new
          g.set red
          g.set Triangle.new 0, 1, 0, Triangle::TRI_TYPE_COUNTER, 11
          g.set Triangle.new 0, 0, 1, Triangle::TRI_TYPE_COUNTER, 99
          g.fillBorderTriangles()
          g
        end

        it 'returns false for 11' do
          grid.isEncircledBy(red, 11).should be_false
        end

        it 'returns false for 99' do
          grid.isEncircledBy(red, 99).should be_false
        end
      end

      context 'when red birom is surrounded by both players' do
        let(:red) { Triangle.new 6, -1, -5, Triangle::TRI_TYPE_START }
        let(:grid) do
          g = Grid.new
          g.set red

          g.set Triangle.new(7, -1, -6, Triangle::TRI_TYPE_COUNTER, 99)
          g.set Triangle.new(7, -2, -5, Triangle::TRI_TYPE_COUNTER, 11)
          g.set Triangle.new(7, -1, -5, Triangle::TRI_TYPE_POINT, 11)

          g.set Triangle.new(5, 0, -5, Triangle::TRI_TYPE_COUNTER, 99)
          g.set Triangle.new(6, 0, -6, Triangle::TRI_TYPE_COUNTER, 11)
          g.set Triangle.new(6, 0, -5, Triangle::TRI_TYPE_POINT, 11)

          g.set Triangle.new(5, -1, -4, Triangle::TRI_TYPE_COUNTER, 99)
          g.set Triangle.new(6, -2, -4, Triangle::TRI_TYPE_COUNTER, 11)
          g.set Triangle.new(6, -1, -4, Triangle::TRI_TYPE_POINT, 11)

          g.fillBorderTriangles()
          g
        end

        it 'returns true for 11' do
          grid.isEncircledBy(red, 11).should be_true
        end

        it 'returns true for 99' do
          grid.isEncircledBy(red, 99).should be_true
        end
      end
    end

    describe '#getCapturedTriangles' do

      context 'with 1 surrounded triangle' do
        let (:root) do
          Triangle.new(0, 0, 1, Triangle::TRI_TYPE_COUNTER, 99)
        end

        let(:grid) do
          g = Grid.new

          g.set Triangle.new(0, 0, 0, Triangle::TRI_TYPE_COUNTER, 11)
          g.set Triangle.new(1, 0, 0, Triangle::TRI_TYPE_COUNTER, 99)
          g.set Triangle.new(0, 1, 0, Triangle::TRI_TYPE_COUNTER, 99)
          g.set root

          g.fillBorderTriangles
          g
        end

        it 'returns 0/0/0 as captured triangle' do
          capturedTriangles = grid.getCapturedTriangles(
            [Triangle.new(0, 0, 1, Triangle::TRI_TYPE_COUNTER, 99)])
          capturedTriangles.should be_matching_coordinates(
            [ Triangle.new(0, 0, 0) ]
          )
        end
      end

      context 'with 4 surrounded triangles' do
        let(:root) do
          # current Counter player 9
          Triangle.new(-2, 5, -3, Triangle::TRI_TYPE_COUNTER, 9)
        end

        let(:grid) do
          g = Grid.new

          # player 9
          g.set Triangle.new(-3, 7, -3, Triangle::TRI_TYPE_COUNTER, 9)
          g.set Triangle.new(-3, 6, -2, Triangle::TRI_TYPE_COUNTER, 9)
          g.set Triangle.new(-3, 5, -1, Triangle::TRI_TYPE_COUNTER, 9)
          g.set Triangle.new(-2, 6, -4, Triangle::TRI_TYPE_COUNTER, 9)
          g.set Triangle.new(-2, 4, -2, Triangle::TRI_TYPE_COUNTER, 9)
          # player 6
          g.set Triangle.new(-3, 6, -3, Triangle::TRI_TYPE_COUNTER, 6)
          g.set Triangle.new(-2, 6, -3, Triangle::TRI_TYPE_COUNTER, 6)
          g.set Triangle.new(-3, 5, -2, Triangle::TRI_TYPE_COUNTER, 6)
          g.set Triangle.new(-2, 5, -2, Triangle::TRI_TYPE_COUNTER, 6)
          g.set root

          g.fillBorderTriangles
          g
        end

        it 'returns 4 captured triangles' do
          capturedTriangles = grid.getCapturedTriangles([root])
          capturedTriangles.should be_matching_coordinates(
            [
              Triangle.new(-3, 6, -3),
              Triangle.new(-2, 6, -3),
              Triangle.new(-3, 5, -2),
              Triangle.new(-2, 5, -2),
            ]
          )
        end
      end

      context 'with 4 surrounded triangles' do

        let(:root) do
          # current Counter player 9
          Triangle.new(-2, 5, -3, Triangle::TRI_TYPE_COUNTER, 9)
        end

        let(:grid) do
          g = Grid.new

          # player 9
          g.set Triangle.new(-3, 7, -3, Triangle::TRI_TYPE_COUNTER, 9)
          g.set Triangle.new(-3, 6, -2, Triangle::TRI_TYPE_COUNTER, 9)
          g.set Triangle.new(-3, 5, -1, Triangle::TRI_TYPE_COUNTER, 9)
          g.set Triangle.new(-2, 6, -4, Triangle::TRI_TYPE_COUNTER, 9)
          g.set Triangle.new(-2, 4, -2, Triangle::TRI_TYPE_COUNTER, 9)
          # player 6
          g.set Triangle.new(-3, 6, -3, Triangle::TRI_TYPE_COUNTER, 6)
          g.set Triangle.new(-2, 6, -3, Triangle::TRI_TYPE_COUNTER, 6)
          g.set Triangle.new(-3, 5, -2, Triangle::TRI_TYPE_COUNTER, 6)

          # now point for 9
          g.set Triangle.new(-2, 5, -2, Triangle::TRI_TYPE_POINT, 9)

          g.set root

          g.fillBorderTriangles
          g
        end

        it 'returns 3 captured triangles' do
          capturedTriangles = grid.getCapturedTriangles([root])
          capturedTriangles.should be_matching_coordinates(
            [
              Triangle.new(-3, 6, -3),
              Triangle.new(-2, 6, -3),
              Triangle.new(-3, 5, -2),
            ]
          )
        end
      end

      context 'with 2 surrounded triangles' do

        let(:root) do
          # current Counter player 9
          Triangle.new(-2, 5, -3, Triangle::TRI_TYPE_COUNTER, 9)
        end

        let(:grid) do
          g = Grid.new

          # player 9
          g.set Triangle.new(-3, 7, -3, Triangle::TRI_TYPE_COUNTER, 9)
          g.set Triangle.new(-3, 6, -2, Triangle::TRI_TYPE_COUNTER, 9)
          g.set Triangle.new(-3, 5, -1, Triangle::TRI_TYPE_COUNTER, 9)
          g.set Triangle.new(-2, 6, -4, Triangle::TRI_TYPE_COUNTER, 9)

          # player 6
          # now counter player 6
          g.set Triangle.new(-2, 4, -2, Triangle::TRI_TYPE_COUNTER, 6)

          g.set Triangle.new(-3, 6, -3, Triangle::TRI_TYPE_COUNTER, 6)
          g.set Triangle.new(-2, 6, -3, Triangle::TRI_TYPE_COUNTER, 6)
          g.set Triangle.new(-3, 5, -2, Triangle::TRI_TYPE_COUNTER, 6)
          g.set Triangle.new(-2, 5, -2, Triangle::TRI_TYPE_COUNTER, 9)

          g.set root

          g.fillBorderTriangles
          g
        end

        it 'returns 2 captured triangles' do
          capturedTriangles = grid.getCapturedTriangles([root])
          capturedTriangles.should be_matching_coordinates(
            [
              Triangle.new(-3, 6, -3),
              Triangle.new(-2, 6, -3),
            ]
          )
        end
      end

      context 'without encirclement' do

        let(:root) do
          Triangle.new(0, 0, 1, Triangle::TRI_TYPE_COUNTER, 99)
        end

        let(:grid) do
          g = Grid.new

          # player 9
          g.set Triangle.new(0, 0, 0, Triangle::TRI_TYPE_COUNTER, 11)
          g.set Triangle.new(1, 0, 0, Triangle::TRI_TYPE_COUNTER, 11)
          g.set Triangle.new(0, 1, 0, Triangle::TRI_TYPE_COUNTER, 99)
          g.set root

          g.fillBorderTriangles
          g
        end

        it 'returns empty array' do
          capturedTriangles = grid.getCapturedTriangles([root])
          capturedTriangles.should == []
        end
      end
    end

    describe '#findSnappingSlots' do
      context 'on an empty grid' do
        let(:grid) { Grid.new }

        it 'returns the same counter coordinates' do
          t = Triangle.new(0, 0, 0, Triangle::TRI_TYPE_COUNTER, 99)
          grid.findSnappingSlots([t]).should be_matching_coordinates([
            {u: 0, v: 0, w: 0}])
        end

        it 'returns the same counter coordinates' do
          t = Triangle.new(1, -1, 0, Triangle::TRI_TYPE_COUNTER, 99)
          grid.findSnappingSlots([t]).should be_matching_coordinates(
            [{u: 1, v: -1, w: 0}])
        end
      end

      context 'when counter overlaps' do

        let(:triangle) do
          Triangle.new(6, 0, -5, Triangle::TRI_TYPE_COUNTER)
        end

        let(:grid) do
          g = Grid.new
          g.set triangle
          g
        end

        it 'returns a vacant neighbour coordinate candidate' do
          [
            {u: 5, v:  1, w: -5},
            {u: 5, v:  0, w: -4},
            {u: 6, v: -1, w: -4},
            {u: 7, v: -1, w: -5},
            {u: 7, v:  0, w: -6},
            {u: 6, v:  1, w: -6},
          ].should include(grid.findSnappingSlots([triangle])[0])
        end
      end
    end

    describe '#overlaps?' do
      context 'on an empty grid' do
        let(:grid) { Grid.new }

        it 'returns false' do
          t = Triangle.new(0, 0, 0, Triangle::TRI_TYPE_COUNTER, 99)
          grid.overlaps?([t]).should be_false
        end
      end

      context 'with overlapping triangles' do
        let(:triangle) do
          Triangle.new(6, 0, -5, Triangle::TRI_TYPE_COUNTER)
        end

        let(:grid) do
          g = Grid.new
          g.set triangle
          g
        end

        it 'returns true' do
          grid.overlaps?([triangle]).should be_true
        end
      end
    end

    class DummyCounter
      include Counter
    end

    describe '#validate!' do

      context 'on empty grid' do
        let(:triangle) do
          Triangle.new(6, 0, -5, Triangle::TRI_TYPE_COUNTER)
        end

        let(:counter) do
          m = DummyCounter.new
          m.triangles = [triangle]
          m
        end

        let(:grid) { Grid.new }

        it 'raises CounterOverlaps' do
          expect do
            grid.validate!(counter)
          end.to raise_error(CounterNotConnected)
        end
      end

      context 'with overlapping triangles' do
        let(:triangle) do
          Triangle.new(6, 0, -5, Triangle::TRI_TYPE_COUNTER)
        end

        let(:counter) do
          m = DummyCounter.new
          m.triangles = [triangle]
          m
        end

        let(:grid) do
          g = Grid.new
          g.set triangle
          g
        end

        it 'raises CounterOverlaps' do
          expect do
            grid.validate!(counter)
          end.to raise_error(CounterOverlaps)
        end
      end

      context 'with one close neighbour' do
        let(:counter) do
          m = DummyCounter.new
          m.triangles = [
            Triangle.new(5, 0, -5, Triangle::TRI_TYPE_COUNTER)
          ]
          m
        end

        let(:grid) do
          g = Grid.new
          g.set Triangle.new(6, 0, -5, Triangle::TRI_TYPE_COUNTER)
          g
        end

        it 'returns true' do
          grid.validate!(counter).should be_true
        end
      end

      context 'with two connecting vertices' do
        let(:counter) do
          m = DummyCounter.new
          m.triangles = [
            Triangle.new(6, 0, -5, Triangle::TRI_TYPE_COUNTER)
          ]
          m
        end

        let(:grid) do
          g = Grid.new
          g.set Triangle.new(5, 1, -5, Triangle::TRI_TYPE_COUNTER)
          g.set Triangle.new(5, 0, -4, Triangle::TRI_TYPE_COUNTER)
          g
        end

        it 'returns true' do
          grid.validate!(counter).should be_true
        end
      end

    end
  end
end
