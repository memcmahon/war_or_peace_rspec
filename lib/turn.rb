class Turn
  attr_reader :player1, :player2, :spoils_of_war, :type

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @spoils_of_war = []
    @type = set_type
  end

  def set_type
    if player1.deck.rank_of_card_at(0) == player2.deck.rank_of_card_at(0) && player1.deck.rank_of_card_at(2) == player2.deck.rank_of_card_at(2) 
      :mutually_assured_destruction
    elsif player1.deck.rank_of_card_at(0) == player2.deck.rank_of_card_at(0)
      :war
    else
      :basic
    end
  end

  def winner
    if @type == :basic
      player1.deck.rank_of_card_at(0) > player2.deck.rank_of_card_at(0) ? player1 : player2
    elsif @type == :war
      player1.deck.rank_of_card_at(2) > player2.deck.rank_of_card_at(2) ? player1 : player2
    else
      "No Winner"
    end
  end

  def pile_cards
    if @type == :basic
      @spoils_of_war << player1.deck.remove_card
      @spoils_of_war << player2.deck.remove_card
    elsif @type == :war
      3.times do
        @spoils_of_war << player1.deck.remove_card
        @spoils_of_war << player2.deck.remove_card
      end
    else
      3.times do
        player1.deck.remove_card
        player2.deck.remove_card
      end
    end
  end
  
  def award_spoils(winner)
    spoils_of_war.each do |card|
      winner.deck.cards << card
    end
  end
end