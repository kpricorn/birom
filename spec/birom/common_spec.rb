require 'birom/common'

module Birom
  describe Common do
    context 'with two nodes' do
      let!(:nodes) { ['A', 'B'] }

      let(:bfs) do
        visited = []
        Common.bfs nodes.shift do |n|
          visited << n
          [nodes.shift].compact
        end
        visited
      end

      it 'visits all nodes' do
        bfs.should  =~ ['A', 'B']
        nodes.should be_empty
      end
    end

    context 'with endless neighbour loop' do
      let(:bfs) do
        Common.bfs 'root' do |n|
          ['neighbour']
        end
        visited
      end

      it 'raises after max_iterations' do
        expect{bfs}.to raise_error
      end
    end
  end
end
