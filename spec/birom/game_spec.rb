require 'birom/game'

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

        let(:join_player_0) { game.join(User.new) }
        let(:join_player_1) { game.join(User.new) }

        it 'creates a game player with id 1' do
          join_player_0
          join_player_1.id.should == 1
        end

        it 'assigns first turn to newly created game player' do
          join_player_0
          join_player_1
          join_player_0.should == game.turn
        end

        it 'sets game to running' do
          join_player_0
          join_player_1
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
          expect {game.join(User.new) }.to raise_error
        end
      end
    end

  end
end
