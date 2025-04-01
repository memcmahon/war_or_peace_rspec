require 'rspec'
require './lib/turn'
require './lib/player'
require './lib/deck'
require './lib/card'

RSpec.describe Turn do
  describe "turn creation" do
    before(:each) do
      @player1 = Player.new('Clarisa', Deck.new([]))
      @player2 = Player.new('Aurora', Deck.new([]))
      @turn = Turn.new(@player1, @player2)
    end

    it "exists" do
      expect(@turn).to be_an_instance_of(Turn)
    end

    it "has readable attributes" do
      expect(@turn.player1).to eq(@player1)
      expect(@turn.player2).to eq(@player2)
      expect(@turn.spoils_of_war).to eq([])
    end
  end

  describe "basic turn" do
    before(:each) do
      @card1 = Card.new(:diamond, 'Queen', 12)
      @card2 = Card.new(:spade, '3', 3)
      @card3 = Card.new(:heart, 'Ace', 14)
      cards = [@card1, @card2, @card3]
      deck = Deck.new(cards)
      @player1 = Player.new('Clarisa', deck)

      @card4 = Card.new(:club, '5', 5)
      @card5 = Card.new(:diamond, 'King', 13)
      @card6 = Card.new(:heart, '2', 2)
      cards2 = [@card4, @card5, @card6]
      deck2 = Deck.new(cards2)
      @player2 = Player.new('Aurora', deck2)

      @turn = Turn.new(@player1, @player2)
    end

    it "has type :basic when top cards have different ranks" do
      expect(@turn.type).to eq(:basic)
    end

    it "can determine winner of basic turn" do
      expect(@turn.winner).to eq(@player1)
    end

    it "can pile cards for basic turn" do
      @turn.pile_cards
      expect(@turn.spoils_of_war).to eq([@card1, @card4])
    end

    it "can award spoils to winner of basic turn" do
      winner = @turn.winner
      @turn.pile_cards
      @turn.award_spoils(winner)

      expect(@player1.deck.cards).to eq([@card2, @card3, @card1, @card4])
      expect(@player2.deck.cards).to eq([@card5, @card6])
    end
  end

  describe "war turn" do
    before(:each) do
      @card1 = Card.new(:diamond, 'Queen', 12)
      @card2 = Card.new(:spade, '3', 3)
      @card3 = Card.new(:heart, 'Ace', 14)
      cards = [@card1, @card2, @card3]
      deck = Deck.new(cards)
      @player1 = Player.new('Clarisa', deck)

      @card4 = Card.new(:club, 'Queen', 12)
      @card5 = Card.new(:diamond, '2', 2)
      @card6 = Card.new(:heart, '3', 3)
      cards2 = [@card4, @card5, @card6]
      deck2 = Deck.new(cards2)
      @player2 = Player.new('Aurora', deck2)

      @turn = Turn.new(@player1, @player2)
    end

    it "has type :war when top cards have same rank" do
      expect(@turn.type).to eq(:war)
    end

    it "can determine winner of war turn" do
      expect(@turn.winner).to eq(@player1)
    end

    it "can pile cards for war turn" do
      @turn.pile_cards
      expect(@turn.spoils_of_war).to eq([@card1, @card4, @card2, @card5, @card3, @card6])
    end

    it "can award spoils to winner of war turn" do
      winner = @turn.winner
      @turn.pile_cards
      @turn.award_spoils(winner)

      expect(@player1.deck.cards).to eq([@card1, @card4, @card2, @card5, @card3, @card6])
      expect(@player2.deck.cards).to eq([])
    end
  end

  describe "mutually assured destruction turn" do
    before(:each) do
      @card1 = Card.new(:diamond, 'Queen', 12)
      @card2 = Card.new(:spade, '3', 3)
      @card3 = Card.new(:heart, 'Ace', 14)
      cards = [@card1, @card2, @card3]
      deck = Deck.new(cards)
      @player1 = Player.new('Clarisa', deck)

      @card4 = Card.new(:club, 'Queen', 12)
      @card5 = Card.new(:diamond, 'King', 13)
      @card6 = Card.new(:heart, 'Ace', 14)
      cards2 = [@card4, @card5, @card6]
      deck2 = Deck.new(cards2)
      @player2 = Player.new('Aurora', deck2)

      @turn = Turn.new(@player1, @player2)
    end

    it "has type :mutually_assured_destruction when top and third cards have same rank" do
      expect(@turn.type).to eq(:mutually_assured_destruction)
    end

    it "returns No Winner for mutually assured destruction turn" do
      expect(@turn.winner).to eq("No Winner")
    end

    it "can pile cards for mutually assured destruction turn" do
      @turn.pile_cards
      expect(@turn.spoils_of_war).to eq([])
      expect(@player1.deck.cards).to eq([])
      expect(@player2.deck.cards).to eq([])
    end

    it "does not award spoils for mutually assured destruction turn" do
      winner = @turn.winner
      @turn.pile_cards
      @turn.award_spoils(winner)

      expect(@player1.deck.cards).to eq([])
      expect(@player2.deck.cards).to eq([])
      expect(@turn.spoils_of_war).to eq([])
    end
  end
end
