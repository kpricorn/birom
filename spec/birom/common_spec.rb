require 'birom/triangle'
require 'birom/common'

module Birom
  describe Common do
    #describe '#bfs' do
    #context 'with two nodes' do
    #let!(:nodes) { ['A', 'B'] }

    #let(:bfs) do
    #visited = []
    #Common.bfs nodes.shift do |n|
    #visited << n
    #[nodes.shift].compact
    #end
    #visited
    #end

    #it 'visits all nodes' do
    #bfs.should  =~ ['A', 'B']
    #nodes.should be_empty
    #end
    #end

    #context 'with endless neighbour loop' do
    #let(:bfs) do
    #Common.bfs 'root' do |n|
    #['neighbour']
    #end
    #visited
    #end

    #it 'raises after max_iterations' do
    #expect{bfs}.to raise_error
    #end
    #end
    #end

    describe '#isWithin' do

      let(:a) { Triangle.new(0, 4, -4) }
      let(:o) { Triangle.new(-3, 2, 2) }

      context 'within' do
        it 'returns true' do
          [
            Triangle.new(-3, 2, 2),
            Triangle.new(-2, 3, 0),
            Triangle.new(-3, 4, 0),
            Triangle.new(0, 3, -3),
            Triangle.new(-1, 4, -3),
          ].each do |t|
            Common.isWithin(a, o, t).should be_true
          end
        end
      end

      context 'outside' do
        it 'returns false' do
          [
            Triangle.new(1, 4, -4),
            Triangle.new(1, 5, -5),
            Triangle.new(1, 2, -2),
            Triangle.new(-3, 1, 2),
            Triangle.new(-4, 5, 0),
          ].each do |t|
            Common.isWithin(a, o, t).should be_false
          end
        end
      end
    end
  end
end
