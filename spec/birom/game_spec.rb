require 'spec_helper'

require 'birom/game'
require 'birom/birom'
require 'birom/grid'

module Birom

  describe Game do
    describe '#initialize' do
      it 'assigns the red birom as starting point' do
        Game.new.red.should == Birom::RED
      end

      it 'creates a moves array' do
        Game.new.moves.should == [Birom::RED]
      end

      it 'creates a players array' do
        Game.new.players.should == []
      end

      it 'is not yet running' do
        Game.new.running.should be_false
      end
    end

    describe '#join' do

      class User; end

      context 'without game players' do
        let(:game) { Game.new }
        let(:game_player) { game.join(User.new) }

        it 'creates a game player with id 0' do
          game_player.id.should == 0
        end

        it 'assigns first turn to newly created game player' do
          game_player.should == game.turn
        end

        it 'keeps game stopped when max number of players reached' do
          game.running.should == false
        end
      end

      context 'existing game players' do
        let(:game) do
          g = Game.new
          g
        end

        let(:yellow) { game.join(User.new) }
        let(:blue) { game.join(User.new) }

        it 'creates a game player with id 1' do
          yellow
          blue.id.should == 1
        end

        it 'assigns first turn to newly created game player' do
          yellow
          blue
          yellow.should == game.turn
        end

        it 'sets game to running' do
          yellow
          blue
          game.running.should == true
        end
      end

      context 'running game' do
        let(:game) do
          g = Game.new
          g.join(User.new)
          g.join(User.new)
          g
        end

        it 'no more players can join' do
          expect {game.join(User.new) }.to raise_error(/Game already running/)
        end
      end
    end

    describe '#take' do
      class User; end
      context 'when game not running' do
        let(:game) { Game.new }
        it 'raises' do
          expect {game.take(nil) }.to raise_error(/Game is not running/)
        end
      end

      context 'when it\'s not the game player\'s turn' do
        let(:game) { Game.new }
        it 'raises' do
          game.join(User.new)
          player = game.join(User.new)
          turn = Turn.new(player, nil)
          expect { game.take(turn) }.to raise_error(/Not player's turn/)
        end
      end

      context 'when game is running' do
        let!(:game) { Game.new }
        let!(:player_0) { game.join(User.new) }
        let!(:player_1) { game.join(User.new) }

        context 'with an overlapping turn' do
          let(:overlappingBirom) do
            Birom.new(
              [
                { u: 0, v: 0, w: 0 },
                { u: 0, v: 1, w: 0 },
                { u: -1, v: 1, w: 0 },
                { u: -1, v: 1, w: 1 }
              ], player_0, Triangle::TRI_TYPE_COUNTER
            )
          end

          it 'raises' do
            turn = Turn.new(player_0, overlappingBirom)
            expect { game.take(turn) }.to raise_error(CounterOverlaps)
          end
        end

        context 'with an overlapping turn' do
          let(:overlappingBirom) do
            Birom.new(
              [
                { u: 0, v: 0, w: 0 },
                { u: 0, v: 1, w: 0 },
                { u: -1, v: 1, w: 0 },
                { u: -1, v: 1, w: 1 }
              ], player_0, Triangle::TRI_TYPE_COUNTER
            )
          end

          it 'raises' do
            turn = Turn.new(player_0, overlappingBirom)
            expect { game.take(turn) }.to raise_error(CounterOverlaps)
          end
        end
      end

      describe 'turn testing' do
        let!(:game) { Game.new }
        let!(:yellow) { game.join(User.new) }
        let!(:blue) { game.join(User.new) }

        context 'with valid turns' do
          let(:valid) do
            [[
              {u: 1, v: 0, w: 0}, {u: 1, v: 0, w: -1}, {u: 2, v: 0, w: -1}, {u: 2, v: -1, w: -1}
            ]]
          end

          it 'should not raise TurnException' do
            valid.each do |counterCoords|
              birom = Birom.new(counterCoords, yellow)
              turn = Turn.new(yellow, birom)
              expect { game.take(turn) }.to_not raise_error(TurnException)
            end
          end
        end

        context 'with invalid turns' do
          let(:invalid) do
            [[
              # only one vertex connected
              {u: 1, v: -1, w: 1}, {u: 1, v: -1, w: 0}, {u: 2, v: -1, w: 0}, {u: 2, v: -2, w: 0}
            ], [
              # no vertices connected
              {u: 0, v: -1, w: 2}, {u: 0, v: -2, w: 2}, {u: 1, v: -2, w: 2}, {u: 1, v: -2, w: 1}
            ], [
              # overlapping
              {u: -1, v: 1, w: 0}, {u: -1, v: 1, w: 1}, {u: -2, v: 1, w: 1}, {u: -2, v: 2, w: 1}
            ]]
          end

          it 'should raise TurnException' do
            invalid.each do |counterCoords|
              birom = Birom.new(counterCoords, yellow)
              turn = Turn.new(yellow, birom)
              expect { game.take(turn) }.to raise_error(TurnException)
            end
          end
        end
      end
    end

  end
end
