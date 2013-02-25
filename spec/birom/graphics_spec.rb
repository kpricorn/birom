require 'spec_helper'

require 'birom/graphics'
require 'birom/grid'

module Birom
  describe Graphics do
    describe '#getOutline' do
      it 'returns outline [{x: <x1>, y: <y1>}, {x: <x1>, y: <y1>}}, ... ]' do
        g = Grid.new
        g.set Triangle.new(-3, 4, -1)
        g.set Triangle.new(-3, 5, -1)
        g.set Triangle.new(-4, 5, -1)
        g.set Triangle.new(-4, 5, 0)

        Graphics.getOutline(g).should be_matching_coordinates([
          { x: 3, y: -1 },
          { x: 4, y: -2 },
          { x: 5, y: -2 },
          { x: 5, y: -1 },
          { x: 4, y: 0 },
          { x: 4, y: -1 }
        ])
      end
    end
  end
end
