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

  def restart
    @cards = []
    @total_value = 0
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

  def push card
    @cards.push(card)
    @total_value += card[:value]
  end

  def puts_cards
    puts"#{@name} has cards"
    puts @cards
    puts"total value = #{@total_value}"
  end

  def name
    @name
  end

end

class Game
  def initialize
    puts "Game start"
    puts "Set Player"
    puts "Enter dealer's name"
    name = gets.chomp
    @dealer = People.new(name,true)
    puts "Enter Player's name"
    name = gets.chomp
    @player = People.new(name,false)
    @deck = Deck.new(4) #use 4 decks
    @deck.shuffle
  end

  def start_game
    2.times do
      @dealer.push(@deck.pop)
      @player.push(@deck.pop)
    end
  end

  def restart_game
    @dealer.restart
    @player.restart
  end

  def status
    puts"dealer status"
    @dealer.puts_cards
    puts"player status"
    @player.puts_cards
  end

  def ask_hit_or_stay people
    puts"#{People.name} do you want hit or stay"
    flow = gets.chomp
    if flow == hit
      people.push(@deck.pop)
      
    end
  end

end

game1 = Game.new
game1.start_game
game1.status

