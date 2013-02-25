require 'spec_helper'
require 'birom/grid'
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

    describe '#getBoundingBox' do
      context 'with 1 triangle' do
        let(:t0) { Triangle.new(0, 0, 0, Triangle::TRI_TYPE_COUNTER) }
        let(:orig) { g = Grid.new(); g.set(t0); g }
        let(:copy) { orig.deepCopy }

        it 'returns equal triangles' do
          orig.get(0, 0, 0).should_not be(copy.get(0, 0, 0))
        end

        it 'copies triangles' do
          orig.get(0, 0, 0).should == copy.get(0, 0, 0)
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
        let (:t3) do
          Triangle.new(0, 0, 1, Triangle::TRI_TYPE_COUNTER, 99)
        end

        let(:points) do
          g = Grid.new
          g.set Triangle.new(1, 0, 0, Triangle::TRI_TYPE_COUNTER, 99)
          g.set Triangle.new(0, 1, 0, Triangle::TRI_TYPE_COUNTER, 99)
          g.set t3
          g.fillBorderTriangles
          g.getPointTriangles([t3])
        end

        it 'returns 0/0/0 as point triangle' do
          points.should == [Triangle.new(0, 0, 0)]
          points[0].playerId.should == 99
          points[0].type.should == Triangle::TRI_TYPE_POINT
        end
      end
    end
  end
end
