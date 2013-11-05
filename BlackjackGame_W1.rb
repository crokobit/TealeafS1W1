#require ‘pry’

Card = Struct.new(:suit, :value ,:show_value)

#bad implementation
def determine_show_value value
  show_value = 0
  if value == 1
    show_value = 'A'
  elsif value == 10
    show_value = 'J'
  elsif value == 10
    show_value = 'Q'
  elsif value == 10
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

  def push card
    @deck.push(card)
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
    total_value_consider_A
  end

  def total_value_consider_A
    @cards.select { |card| card[:show_value] == 'A' }.count.times do
      @total_value +=10 if ( @total_value + 10 ) <= 21
    end
  end

  def puts_cards
    role = ( @dealer ? 'dealer' : 'player' )
    puts"#{role} #{@name} has cards"
    puts @cards
    puts"total value = #{@total_value}"
    puts ''
  end

  def name
    @name
  end

  def total_value
    @total_value
  end

  def clean_card
    @cards = []
  end

  def clean_total_value
    @total_value = 0
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
    puts ''
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
    #puts"dealer status"
    @dealer.puts_cards
    #puts"player status"
    @player.puts_cards
  end

  def hit_or_stay who


    if who == 'dealer'
      block = @dealer
    elsif who == 'player'
      block = @player
    else
      puts "ERROR!!!!"
    end


    puts"#{block.name} #{who} do you want to hit or to stay"
    flow = gets.chomp
    puts ''
    if flow == 'hit'
      puts"#{block.name} #{who} hit a card"
#      binding.pry
      block.push(@deck.pop)
    elsif flow == 'stay'
      puts"#{block.name} #{who} stay"
    else
      puts "ERROR"
    end
    puts ''
    flow

  end

  def one_of_people_BJ_or_busted
    not ( ( @dealer.status  == 'safe' ) && ( @player.status == 'safe') )
  end

  def end_game
    if one_of_people_BJ_or_busted
      if ( ( @dealer.status == 'BlackJack' ) || (@player.status == 'busted'))
        puts 'dealer win!!'
        true
      elsif ( ( @player.status == 'BlackJack' ) || (@dealer.status == 'busted'))
        puts 'player win!!'
        true
      elsif ( @dealer.total_value == @player.total_value )
        puts "draw ~~~!!!"
        true
      else
        puts 'ERROR'
      end
    end
  end

  def end_game_compare
    if @dealer.total_value > @player.total_value
      puts 'dealer win'
    elsif @dealer.total_value < @player.total_value
      puts 'player win'
    else
      puts 'draw!!!~~'
    end
  end

  def end_deal_cards
    @dealer.clean_card
    @dealer.clean_total_value
    @player.clean_card
    @player.clean_total_value
    @deck.shuffle
  end

end


  #dealer_proc = Proc.new {@dealer}
  #player_proc = Proc.new {@player}
  game = Game.new
  player_array = ['player','dealer']
  play_or_not = true



while play_or_not
    game.start_game
    game.status
    player_array.each do |who|

      do_what = ''

      while ( ( do_what != 'stay' ) && ( game.one_of_people_BJ_or_busted != true ) )
        do_what = game.hit_or_stay(who)
        game.status
      end

      if ( ( who == 'dealer' ) && ( do_what == 'stay' ) )
        game.end_game_compare
      end

      if ( game.end_game == true && who == 'dealer' ) #dealer last
        break
      end

    end

  game.end_deal_cards

  puts "play game? yes or no"
  temp = gets.chomp
  if (temp == 'yes')
    play_or_not = true
  else
    play_or_not = false
  end



end