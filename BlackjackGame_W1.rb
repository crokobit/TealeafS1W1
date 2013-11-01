Card = Struct.new(:suit, :value ,:show_value)

#bad implementation
def determine_show_value value
  show_value = 0
  if value == 1
    show_value = 'A'
  elsif value == 11
    show_value = 'J'
  elsif value == 12
    show_value = 'Q'
  elsif value == 13
    show_value = 'K'
  else
    show_value = value
  end
  show_value
end

class Deck
  def initialize how_many_decks
    @deck = []
    suits_array = ['♠','♥','♣','♦']
    how_many_decks.times do
      suits_array.each do |suit|
        counter = 1
        while counter <=13
          card = Card.new(suit,counter,determine_show_value(counter))
          counter += 1
          @deck.push card
        end
      end
    end
  end

  def puts_all_cards
    puts @deck
  end

  def shuffle
    @deck.shuffle!
  end

  def pop
    @deck.pop
  end
end

class People
  def initialize ( name , dealer_or_not )
    @name = name
    @cards = []
    @total_value = 0
    @dealer = dealer_or_not
  end

  def is_dealer
    @dealer = true
  end

  def status
    if @total_value > 21
      'busted'
    elsif @total_value < 21
      'safe'
    elsif @total_value == 21
      'BlackJack'
    else
      puts 'ERROR!! HERE'
    end
  end

  def get_card card
    @cards.push(card)
    @total_value += card[:value]
  end

  def puts_cards
    puts"#{@name} has cards"
    puts @cards
    puts"total value = #{@total_value}"
  end

end

deck = Deck.new(3)
deck.shuffle
#deck1.puts_all_cards
#puts deck1.pop_card
people1 = People.new('Ivan',false)
people1.puts_cards
people1.get_card(deck.pop)
people1.puts_cards