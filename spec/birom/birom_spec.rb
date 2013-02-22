require 'spec_helper'
require 'birom/birom'

module Birom
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
          expect{Birom.new(coordinates)}.to raise_error
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
          expect{Birom.new(coordinates)}.to raise_error
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
          expect{Birom.new(coordinates)}.to raise_error
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
          expect{Birom.new(coordinates)}.to raise_error
        end
      end

    end
  end
end
