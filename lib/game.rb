require './lib/turn'
class Game
  attr_reader :player1, :player2, :turn_count

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @turn_count = 0
  end

  def start
    p "Welcome to War! (or Peace) This game will be played with 52 cards."
    p "The players today are #{player1.name} and #{player2.name}."
    p "Type 'GO' to start the game!"
    p "------------------------------------------------------------------"

    input = gets.chomp
    if input.upcase == "GO"
      play_game
    else
      p "Invalid input. Please type 'GO' to start the game."
      start
    end
  end

  def play_game
    while @turn_count < 1_000_000
      @turn_count += 1
      turn = Turn.new(player1, player2)

      turn.pile_cards

      if turn.type != :mutually_assured_destruction
        turn.award_spoils(turn.winner)
      end
      
      if turn.type == :basic
        p "Turn #{@turn_count}: #{turn.winner.name} won #{turn.spoils_of_war.count} cards"
      elsif turn.type == :war
        p "Turn #{@turn_count}: WAR - #{turn.winner.name} won #{turn.spoils_of_war.count} cards"
      elsif turn.type == :mutually_assured_destruction
        p "Turn #{@turn_count}: *mutually assured destruction* 6 cards removed from play"
      end

      if player1.has_lost?
        p "*~*~*~* #{player2.name} has won the game! *~*~*~*"
        return
      elsif player2.has_lost?
        p "*~*~*~* #{player1.name} has won the game! *~*~*~*"
        return
      end
    end

    p "---- DRAW ----"
  end
end 