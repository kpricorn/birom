require 'birom/triangle'
require 'birom/common'

module Birom
  describe Common do
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
