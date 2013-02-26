require 'spec_helper'

require 'birom/move'
require 'birom/triangle'

module Birom

  class DummyMove
    include Move
    attr_accessor :triangles
  end

  describe Move do

    describe '#getVertices' do
      context 'with a single triangle' do
        let(:move) do
          m = DummyMove.new
          m.triangles = [
            Triangle.new(-1, 1, 1),
          ]
          m
        end

        it 'returns x/y coordinates of vertices' do
          move.getVertices.should be_matching_coordinates([
            {:x=>1, :y=>0},
            {:x=>0, :y=>1},
            {:x=>0, :y=>0},
            ])
        end
      end

      context 'with a move' do
        let(:move) do
          m = DummyMove.new
          m.triangles = [
            Triangle.new(-1, 1, 1),
            Triangle.new(-1, 1, 0),
            Triangle.new(0,  1, 0),
            Triangle.new(0,  0, 0),
          ]
          m
        end

        it 'returns x/y coordinates of vertices' do
          move.getVertices.should be_matching_coordinates([
            {:x=>1, :y=>0},
            {:x=>0, :y=>1},
            {:x=>0, :y=>0},
            {:x=>1, :y=>-1},
            {:x=>0, :y=>-1},
            {:x=>-1, :y=>0}])
        end
      end
    end

    describe '#connected?' do
      let(:move) do
        m = DummyMove.new
        m.triangles = [
          Triangle.new(-1, 1, 1),
          Triangle.new(-1, 1, 0),
          Triangle.new(0,  1, 0),
          Triangle.new(0,  0, 0),
        ]
        m
      end

      context 'with 2 overlapping vertices' do
        let(:neighbours) do [
            Triangle.new(-1, 0, 2),
            Triangle.new(0, -1, 1),
          ]
        end

        it 'returns true' do
          move.connected?(neighbours).should be_true
        end
      end

      context 'with 1 overlapping vertex' do
        let(:neighbours) do [
            Triangle.new(-1, 0, 2),
            Triangle.new(-3, 7, -4),
          ]
        end

        it 'returns false' do
          move.connected?(neighbours).should be_false
        end
      end

      context 'with 0 overlapping vertex' do
        it 'returns false' do
          move.connected?([]).should be_false
        end
      end
    end

  end
end
