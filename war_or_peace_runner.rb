require './lib/card'
require './lib/deck'
require './lib/player'
require './lib/game'

# Create a standard deck of 52 cards
suits = [:heart, :diamond, :spade, :club]
values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]

cards = []
suits.each do |suit|
  values.each_with_index do |value, index|
    cards << Card.new(suit, value, ranks[index])
  end
end

# Shuffle the cards
cards.shuffle!

# Split the cards into two decks
deck1 = Deck.new(cards[0..25])
deck2 = Deck.new(cards[26..51])

# Create players
player1 = Player.new('Megan', deck1)
player2 = Player.new('Aurora', deck2)

# Create and start the game
game = Game.new(player1, player2)
game.start 