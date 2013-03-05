require 'birom/game'

module Birom
  # Testing based on
  # http://birom.net/424843/Rules
  describe 'Birom Rule testing' do
    class User; end

    let!(:game) { Game.new }
    let!(:yellow) { game.join(User.new) }
    let!(:blue) { game.join(User.new) }
    describe '3. Adding On' do
      context 'with two sides touching' do
        it 'should pass Figure 1' do
          expect { game.take(Turn.new(Birom.new [ { u: -1,  v: 0, w: 1 }, { u: 0,  v: 0, w: 1 }, { u: 0, v: -1, w: 1 }, { u: 0, v: -1, w: 2 } ], yellow), yellow) }.not_to raise_error(TurnException)
        end

        it 'should pass Figure 2' do
          expect { game.take(Turn.new(Birom.new [ { u: -1,  v: 0, w: 1 }, { u: 0,  v: 0, w: 1 }, { u: 0, v: -1, w: 1 }, { u: 0, v: -1, w: 2 } ], yellow), yellow) }.not_to raise_error(TurnException)
        end

        it 'should pass Figure 3' do
          expect { game.take(Turn.new(Birom.new [ { u: 0,  v: 1, w: -1 }, { u: 1,  v: 1, w: -1 }, { u: 1, v: 0, w: -1 }, { u: 1, v: 0, w: 0 } ], yellow), yellow) }.not_to raise_error(TurnException)
          expect { game.take(Turn.new(Birom.new [ { u: 1,  v: -1, w: 0 }, { u: 1,  v: -1, w: 1 }, { u: 0, v: -1, w: 1 }, { u: 0, v: 0, w: 1 } ], blue), blue) }.not_to raise_error(TurnException)
          expect { game.take(Turn.new(Birom.new [ { u: -1,  v: 0, w: 1 }, { u: -2,  v: 1, w: 2 }, { u: -2, v: 0, w: 2 }, { u: -1, v: 0, w: 2 } ], yellow), yellow) }.not_to raise_error(TurnException)
        end
      end

      context 'with two corners touching' do
        it 'should pass Figure 1' do
          game.take(Turn.new(yellow, Birom.new([ { u: -2,  v: 1, w: 1 }, { u: -2,  v: 2, w: 1 }, { u: -2, v: 2, w: 0 }, { u: -1, v: 2, w: 0 } ], yellow)))
          game.take(Turn.new(blue, Birom.new([ { u: 0,  v: 0, w: 1 }, { u: 0,  v: -1, w: 1 }, { u: 1, v: -1, w: 1 }, { u: 1, v: -1, w: 0 } ], blue)))
          game.take(Turn.new(yellow, Birom.new([ { u: 0,  v: 1, w: -1 }, { u: 1,  v: 1, w: -1 }, { u: 1, v: 0, w: -1 }, { u: 1, v: 0, w: 0 } ], yellow)))
          game.take(Turn.new(blue, Birom.new([ { u: 0,  v: -1, w: 2 }, { u: 0,  v: -2, w: 2 }, { u: 1, v: -2, w: 2 }, { u: 1, v: -2, w: 1 } ], blue)))
          game.take(Turn.new(yellow, Birom.new([ { u: -2,  v: 0, w: 2 }, { u: -2,  v: 0, w: 3 }, { u: -2, v: -1, w: 3 }, { u: -1, v: -1, w: 3 } ], yellow)))
          [[-1, 0, 1], [-1, 0, 2], [-1, -1, 2]].each do |pointCoords|
            point = game.grid.get(*pointCoords)
            point.type.should == Triangle::TRI_TYPE_POINT
            point.player.should == yellow
          end
        end

        it 'should pass Figure 2' do
          game.take(Turn.new(yellow, Birom.new([ { u: 0,  v: 1, w: -1 }, { u: 1,  v: 1, w: -1 }, { u: 1, v: 0, w: -1 }, { u: 1, v: 0, w: 0 } ], yellow)))
          game.take(Turn.new(blue, Birom.new(  [ { u: 0,  v: 0, w: 1 }, { u: 0,  v: -1, w: 1 }, { u: 1, v: -1, w: 1 }, { u: 1, v: -1, w: 0 } ], blue)))
          game.take(Turn.new(yellow, Birom.new([ { u: -2,  v: 1, w: 1 }, { u: -2,  v: 1, w: 2 }, { u: -2, v: 0, w: 2 }, { u: -1, v: 0, w: 2 }] , yellow)))

          # 3 new point stones should be added to the grid
          point = game.grid.get(-1, 0, 1)
          point.type.should == Triangle::TRI_TYPE_POINT
          point.player.should == yellow
        end

        it 'should pass Figure 2' do
          game.take(Turn.new(yellow, Birom.new([ { u: -2,  v: 1, w: 1 }, { u: -2,  v: 2, w: 1 }, { u: -2, v: 2, w: 0 }, { u: -1, v: 2, w: 0 } ], yellow)))
          game.take(Turn.new(blue, Birom.new(  [ { u: -1,  v: 0, w: 1 }, { u: 0,  v: 0, w: 1 }, { u: 0, v: -1, w: 1 }, { u: 0, v: -1, w: 2 } ], blue)))
          game.take(Turn.new(yellow, Birom.new([ { u: -2,  v: 0, w: 2 }, { u: -2,  v: 0, w: 3 }, { u: -2, v: -1, w: 3 }, { u: -1, v: -1, w: 3 }] , yellow)))

          # 2 new point stones should be added to the grid
          [[-1, 0, 2], [-1, -1, 2]].each do |pointCoords|
            point = game.grid.get(*pointCoords)
            point.type.should == Triangle::TRI_TYPE_POINT
            point.player.should == yellow
          end
        end
      end

      context '5. Victory by Points' do
        it'should pass Figure 1' do
          game.take(Turn.new(yellow, Birom.new( [ { u: -1,  v: 2, w: 0 }, { u: -2,  v: 2, w: 0 }, { u: -2, v: 2, w: 1 }, { u: -2, v: 1, w: 1 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: -1,  v: 0, w: 1 }, { u: -1,  v: 0, w: 2 }, { u: -2, v: 0, w: 2 }, { u: -2, v: 1, w: 2 } ], blue)))
          # 1 point))
          game.take(Turn.new(yellow, Birom.new( [ { u: 1,  v: 0, w: 0 }, { u: 1,  v: -1, w: 0 }, { u: 1, v: -1, w: 1 }, { u: 0, v: -1, w: 1 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 1,  v: -2, w: 1 }, { u: 1,  v: -2, w: 2 }, { u: 0, v: -2, w: 2 }, { u: 0, v: -1, w: 2 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: -3,  v: 1, w: 2 }, { u: -3,  v: 1, w: 3 }, { u: -3, v: 0, w: 3 }, { u: -2, v: 0, w: 3 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: -1,  v: -1, w: 2 }, { u: -1,  v: -1, w: 3 }, { u: -1, v: -2, w: 3 }, { u: 0, v: -2, w: 3 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: 1, v: 1, w: -1 }, { u: 0, v: 1, w: -1 }, { u: 0, v: 2, w: -1 }, { u: 0, v: 2, w: -2 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 1,  v: 0, w: -1 }, { u: 2,  v: 0, w: -1 }, { u: 2, v: -1, w: -1 }, { u: 2, v: -1, w: 0 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: -3,  v: 2, w: 1 }, { u: -3,  v: 2, w: 2 }, { u: -4, v: 2, w: 2 }, { u: -4, v: 3, w: 2 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 0, v: 3, w: -2 }, { u: -1, v: 3, w: -2 }, { u: -1, v: 3, w: -1 }, { u: -1, v: 2, w: -1 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: 0, v: -3, w: 3 }, { u: 0, v: -3, w: 4 }, { u: -1, v: -3, w: 4 }, { u: -1, v: -2, w: 4 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: -4, v: 4, w: 0 }, { u: -4, v: 4, w: 1 }, { u: -4, v: 3, w: 1 }, { u: -3, v: 3, w: 1 } ], blue)))
          # 2 points))
          game.take(Turn.new(yellow, Birom.new( [ { u: -3, v: 4, w: -1 }, { u: -2, v: 4, w: -1 }, { u: -2, v: 3, w: -1 }, { u: -2, v: 3, w: 0 } ], yellow)))
          # 1 point))
          game.take(Turn.new(blue, Birom.new( [ { u: -2, v: -2, w: 4 }, { u: -2, v: -1, w: 4 }, { u: -3, v: -1, w: 4 }, { u: -3, v: -1, w: 5 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: -1, v: 4, w: -3 }, { u: -1, v: 4, w: -2 }, { u: -2, v: 4, w: -2 }, { u: -2, v: 5, w: -2 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 1, v: 3, w: -4 }, { u: 1, v: 3, w: -3 }, { u: 0, v: 3, w: -3 }, { u: 0, v: 4, w: -3 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: 3, v: -3, w: 0 }, { u: 3, v: -2, w: 0 }, { u: 2, v: -2, w: 0 }, { u: 2, v: -2, w: 1 } ], yellow)))
          # 2 point))
          # 4 captured))
          game.take(Turn.new(blue, Birom.new( [ { u: 1, v: 2, w: -3 }, { u: 2, v: 2, w: -3 }, { u: 2, v: 1, w: -3 }, { u: 2, v: 1, w: -2 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: -2, v: -3, w: 5 }, { u: -2, v: -2, w: 5 }, { u: -3, v: -2, w: 5 }, { u: -3, v: -2, w: 6 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 1, v: -3, w: 2 }, { u: 1, v: -3, w: 3 }, { u: 1, v: -4, w: 3 }, { u: 2, v: -4, w: 3 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: 4, v: -4, w: 1 }, { u: 4, v: -5, w: 1 }, { u: 4, v: -5, w: 2 }, { u: 3, v: -5, w: 2 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 3, v: -1, w: -1 }, { u: 3, v: -2, w: -1 }, { u: 4, v: -2, w: -1 }, { u: 4, v: -2, w: -2 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: 5, v: -3, w: -1 }, { u: 4, v: -3, w: -1 }, { u: 4, v: -3, w: 0 }, { u: 4, v: -4, w: 0 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 3, v: 1, w: -3 }, { u: 3, v: 1, w: -4 }, { u: 4, v: 1, w: -4 }, { u: 4, v: 0, w: -4 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: 6, v: -2, w: -3 }, { u: 5, v: -2, w: -3 }, { u: 5, v: -2, w: -2 }, { u: 5, v: -3, w: -2 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 5, v: -1, w: -3 }, { u: 5, v: -1, w: -4 }, { u: 6, v: -1, w: -4 }, { u: 6, v: -2, w: -4 } ], blue)))
          # 8 triangles common ground (captured by blue)

          [ [0, -1, 1], [1, -1, 1], [1, -1, 0], [1, 0, 0], [1, 1, -1], [0, 1, -1], [0, 2, -1], [0, 2, -2] ].each do |commonGroundCoords|
            commonGround = game.grid.get(*commonGroundCoords)
            commonGround.type.should == Triangle::TRI_TYPE_COMMON
            commonGround.player.should be_undefined
          end
          # blue: 10 points - yellow: 9 points
          yellowPoints = game.grid.triangles.values.select do |t|
            t.type == Triangle::TRI_TYPE_POINT && t.player == yellow
          end.reduce(:+)
          bluePoints = game.grid.triangles.values.select do |t|
            t.type == Triangle::TRI_TYPE_POINT && t.player == blue
          end.reduce(:+)

          yellowPoints.should == 9
          bluePoints.should == 10
        end
      end

      context '8. Encirclement' do
        it 'Figure 1: yellow encircles the central counter' do
          game.take(Turn.new(yellow, Birom.new( [ { u: 0,  v: 1, w: -1 }, { u: 1,  v: 1, w: -1 }, { u: 1,  v: 0, w: -1 }, { u: 1,  v: 0, w: 0 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 0,  v: 2, w: -1 }, { u: 0,  v: 2, w: -2 }, { u: 1,  v: 2, w: -2 }, { u: 1,  v: 1, w: -2 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: -1,  v: 2, w: 0 }, { u: -2,  v: 2, w: 0 }, { u: -2,  v: 2, w: 1 }, { u: -2,  v: 1, w: 1 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 0,  v: 3, w: -2 }, { u: -1,  v: 3, w: -2 }, { u: -1,  v: 3, w: -1 }, { u: -1,  v: 2, w: -1 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: -1,  v: 0, w: 2 }, { u: -1,  v: 0, w: 1 }, { u: 0,  v: 0, w: 1 }, { u: 0,  v: -1, w: 1 } ], yellow)))
          game.winners.should == [yellow]
        end

        it 'Figure 2: blue encircles the central counter via common ground' do
          game.take(Turn.new(yellow, Birom.new( [ { u: 0,  v: 1, w: -1 }, { u: 1,  v: 1, w: -1 }, { u: 1,  v: 0, w: -1 }, { u: 1,  v: 0, w: 0 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: -1,  v: 2, w: 0 }, { u: -2,  v: 2, w: 0 }, { u: -2,  v: 2, w: 1 }, { u: -2,  v: 1, w: 1 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: -1,  v: 0, w: 2 }, { u: -1,  v: -1, w: 2 }, { u: 0,  v: -1, w: 2 }, { u: 0,  v: -1, w: 1 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 1,  v: -1, w: 0 }, { u: 2,  v: -1, w: 0 }, { u: 2,  v: -1, w: -1 }, { u: 2,  v: 0, w: -1 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: -3,  v: 2, w: 1 }, { u: -3,  v: 2, w: 2 }, { u: -3,  v: 1, w: 2 }, { u: -2,  v: 1, w: 2 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 0,  v: 2, w: -1 }, { u: 0,  v: 2, w: -2 }, { u: 1,  v: 2, w: -2 }, { u: 1,  v: 1, w: -2 } ], blue)))
          game.winners.should == [blue]

        end

        it 'Figure 2: yellow encircles the central counter via common ground' do
          # create game in test: -> blue first player
          game = Game.new
          blue = game.join(User.new)
          yellow = game.join(User.new)

          game.take(Turn.new(blue, Birom.new( [ { u: 0,  v: 1, w: -1 }, { u: 1,  v: 1, w: -1 }, { u: 1,  v: 0, w: -1 }, { u: 1,  v: 0, w: 0 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: 1,  v: -1, w: 0 }, { u: 1,  v: -1, w: 1 }, { u: 1,  v: -2, w: 1 }, { u: 2,  v: -2, w: 1 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 2,  v: -1, w: 0 }, { u: 2,  v: -2, w: 0 }, { u: 3,  v: -2, w: 0 }, { u: 3,  v: -2, w: -1 } ], blue)))
          game.take(Turn.new(yellow, Birom.new( [ { u: 0,  v: 2, w: -1 }, { u: 0,  v: 2, w: -2 }, { u: 1,  v: 2, w: -2 }, { u: 1,  v: 1, w: -2 } ], yellow)))
          game.take(Turn.new(blue, Birom.new( [ { u: 2,  v: 0, w: -2 }, { u: 3,  v: 0, w: -2 }, { u: 3,  v: -1, w: -2 }, { u: 3,  v: -1, w: -1 } ], blue)))
          [ [2, 0, -1], [2, -1, -1] ].each do |pointCoords|
            point = game.grid.get(*pointCoords)
            point.type.should == Triangle::TRI_TYPE_POINT
            point.player.should == blue
          end
        end
      end

    end
  end
end
