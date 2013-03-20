require 'spec_helper'
require 'birom/birom'

module Birom
  describe VectorBirom do
    describe '#initialize' do

      context 'with invalid arguments' do
        it 'raises' do
          expect{VectorBirom.new('a', 'b', 'c')}.to raise_error(/need to be numbers/)
        end
      end
    end

    describe '#triangles' do
      it 'converts u, v and rotation to triangles hash' do
        VectorBirom.new(0, 0, 180).triangles.should == [
          Triangle.new(0, 1,  0),
          Triangle.new(0, 0,  0),
          Triangle.new(1, 0,  0),
          Triangle.new(1, 0, -1),
        ]
      end

    end
  end

  describe Birom do
    describe '#initialize' do

      context 'with valid coordinates' do
        let(:coordinates) do [
          {u: -1, v: 1, w: 1},
          {u: -1, v: 1, w: 0},
          {u: 0,  v: 1, w: 0},
          {u: 0,  v: 0, w: 0},
        ]
        end
        it 'returns creates Birom' do
          Birom.new(coordinates).should be_an_instance_of(Birom)
        end
      end

      context 'with valid coordinates' do
        let(:coordinates) do [
          {u: 0,  v: 1, w: 0},
          {u: -1, v: 1, w: 1},
          {u: 0,  v: 0, w: 0},
          {u: -1, v: 1, w: 0},
        ]
        end
        it 'returns creates Birom' do
          Birom.new(coordinates).should be_an_instance_of(Birom)
        end
      end

      context 'with invalid coordinates' do
        let(:coordinates) do [
          {u: -1, v: 1, w: 1},
          {u: -1, v: 1, w: 0},
          {u: 0,  v: 1, w: 0},
          {u: 0,  v: 1, w: -1},
        ]
        end

        it 'raises' do
          expect{Birom.new(coordinates)}.to raise_error(/Not a birom/)
        end
      end

      context 'with invalid coordinates' do
        let(:coordinates) do [
          {u: -3, v: 4, w: 0},
          {u: -3, v: 3, w: 1},
          {u: -3, v: 3, w: 0},
          {u: -2, v: 3, w: 0},
        ]
        end

        it 'raises' do
          expect{Birom.new(coordinates)}.to raise_error(/Not a birom/)
        end
      end

      context 'with invalid coordinates' do
        let(:coordinates) do [
          {u: -3, v: 3, w: 1},
          {u: -3, v: 3, w: 0},
          {u: -2, v: 3, w: 0},
          {u: -2, v: 2, w: 1},
        ]
        end

        it 'raises' do
          expect{Birom.new(coordinates)}.to raise_error(/Not a birom/)
        end
      end

      context 'with invalid coordinates' do
        let(:coordinates) do [
          {u: 1, v: -3, w: 2},
          {u: 1, v: -3, w: 3},
          {u: 1, v: -3, w: 3},
          {u: 1, v: -3, w: 2},
        ]
        end

        it 'raises' do
          expect{Birom.new(coordinates)}.to raise_error(/Not a birom/)
        end
      end

      context 'with invalid arguments' do
        it 'raises' do
          expect{Birom.new(nil)}.to raise_error(/Coordinates is not an array/)
        end
      end

      context 'when number of coordinates does not match' do
        let(:coordinates) do [
          {u: 1, v: -3, w: 2},
          {u: 1, v: -3, w: 2},
        ]
        end

        it 'raises' do
          expect{Birom.new(coordinates)}.to raise_error(/Number of coordinates does not match/)
        end
      end

    end

    describe '#new_from_uv_and_rotation' do
      it 'creates birom with triangles' do
        triangles = Birom.new_from_uv_and_rotation(0, 0, 0).triangles
        triangles.should == [
          Triangle.new(1, 0, -1),
          Triangle.new(1, 1, -1),
          Triangle.new(0, 1, -1),
          Triangle.new(0, 1,  0),
        ]
      end

      it 'creates birom with triangles' do
        triangles = Birom.new_from_uv_and_rotation(0, 0, 180).triangles
        triangles.should == [
          Triangle.new(0, 1,  0),
          Triangle.new(0, 0,  0),
          Triangle.new(1, 0,  0),
          Triangle.new(1, 0, -1),
        ]
      end
    end
  end
end
