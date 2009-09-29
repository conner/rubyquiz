#!/usr/bin/env ruby

# @author = Conner Peirce
# http://rubyquiz.com quiz #1
# note: rewrite will make it more cmd line friendly (-d/--d switch?)




class Deck
  
  attr_reader :deck
  
  def initialize
    @deck = make_deck
  end
  
  def make_deck  
    card_names =  [ :ace, :two, :three, :four, :five, :six, :seven, :eight, :nine, :ten, :jack, :queen, :king ]
    suits =       [ :clubs, :diamonds, :hearts, :spades ]
    temp = []
    for index in 0.upto(53)
      temp[index] = 
          case index
             when 0..12: Card.new( card_names[index], :clubs, index+1 )
             when 13..25: Card.new( card_names[index-13], :diamonds, index+1 )
             when 26..38: Card.new( card_names[index-26], :hearts, index+1 )
             when 39..51: Card.new( card_names[index-39], :spades, index+1 )
             when 52: Card.new( :a_joker, :spades, 53 )
             when 53: Card.new( :b_joker, :spades, 53 )
           end
      
    end
    temp
  end
  
  def push( card )
    @cards.push( card )
  end
  
  # moves card the number of places given, acts as if deck is circular
  def move_card( card, places )
    
    n = places
    card_locus = @deck.index( card )
    while (n != 0) do
      
      if (card_locus + 1 < @deck.length )
        @deck[card_locus], @deck[card_locus +1] = @deck[card_locus+1], @deck[card_locus]
        card_locus = card_locus+1
      else
        card = @deck.slice!(card_locus)
        @deck.insert(1, card)
        card_locus = 1
        
      end
        # subtract 1 from n
        n -= 1
      
    end
    
  end
  
  
  # will move cards above top joker below bottom joker, and vice-versa
  def joker_split
    jokers_loci = self.find_jokers
    
    top_pos = jokers_loci.min
    
    cards_above = @deck.slice!(0,top_pos)
    
    jokers_loci = self.find_jokers
    bottom_pos = jokers_loci.max
    cards_below = @deck.slice!(bottom_pos+1,52) # 52 is max possible cards below last card
    
    @deck.insert(0, cards_below) if (cards_below)
    @deck.insert(-1, cards_above) if (cards_above)
    @deck.flatten! 
  end
  
  def find_jokers
    [ @deck.index(Card.new( :a_joker, :spades, 53 )), @deck.index(Card.new( :b_joker, :spades, 53 )) ]
  end
  
  # returns value of card at pos
  def value_of( pos )
    @deck[ pos ].value
  end
  
  def pull_push( num_cards )
    length = @deck.length
    pulled = @deck.slice!( 0, num_cards )
    @deck.insert(length-1-num_cards, *pulled)
  end
    
  def pop
    @deck.pop
  end
end

class Card
  
  attr_reader :face, :suit, :value
  
  def initialize(face, suit, value)
    @face = face
    @suit = suit
    @value = value
  end
  
  def inspect
    (@value > 52) ? "***#{@face.to_s.gsub('_',' ')} (#{@value})***" : "#{@face.to_s} of #{@suit.to_s} (#{@value})"
  end
  
  def is_joker?; @value > 52; end
  
  def ==(card)
    ((self.face==card.face) and (self.suit==card.suit) and (self.value==card.value))
  end
end

# upcase string, take only letters A-Z
# pad s.t. we can produce good chunks
# make 5 char long chunks
# remove trailing whitespace
def message_maker( string )
  message = string.upcase.scan(/[A-Z]*/).join
  message << "X" while (message.length%5 != 0)
  message.gsub!(/\w{5}/){|word| word + " "}
  message.rstrip!  
  
  message
end

# generates a keystream of given length (chunks that are multiples of 5)
def keystream_maker( length )
  cipher_deck = Deck.new
  numbered_keystream = []
  char = 1
  while char <= length do
    
    cipher_deck.move_card(Card.new(:a_joker, :spades, 53), 1)
    cipher_deck.move_card(Card.new(:b_joker, :spades, 53), 2)
    cipher_deck.joker_split
    cipher_deck.pull_push( cipher_deck.value_of(53) )
    
    # non-destructive:
    value = cipher_deck.value_of( cipher_deck.value_of(0) )
    
    if value <= 52
      numbered_keystream << value.to_s + ' '
      numbered_keystream << ' ' if (char % 5 == 0) and (char != length)
      char += 1
    end
    
  end # char while loop
    # for each char do:
  
  
    
    # 
    # 5. convert top card to value, count down that many cards from top, with top card being #1, use card directly after count - so if top of deck looks like 2 3 4, we look at the 4 => returning "D", step does not alter deck, if joker - returns nothing, have to repeat 1..5 to get letter
    
      #"DWJXH YRFDG TMSHP UURXJ"
  
    #if char multiple of 5, and not the last char, append a " ", to make words
    number_decoder(numbered_keystream.to_s.strip)
          
end

# takes string of letters, gives us string of numbers
def number_encoder( input )
  output = ""
  
  # build letter to number hash
  translator = Hash.new
  letters = ('A'..'Z').to_a
  letters.each_index{|i| translator[ letters[i] ] = i+1 }

  
  # seperates into chunks
  input.each(' ') do |chunk|
    chunk.each_char() { |char| output << translator[char].to_s + ' ' }
  end
  output.rstrip!
  output  
end

# takes string of numbers, creates string of letters
# ( assumes `proper' format )
def number_decoder( input )
  output = ""
  
  # build number to letter hash
  translator = Hash.new
  letters = ('A'..'Z').to_a
  letters.each_index{|i| translator [(i+1).to_s] = letters[i] }
  
  input.each(' ') do |nibble|

    
    num = nibble.strip.to_i
    if (num == 0 or num.nil?) then output << " "
    else
      case (num-1)/26
      when 0 then output << translator[num.to_s]# + ' '
      when 1 then output << translator[(num - 26).to_s]
      end
    end
  end
  
  output
end

def number_summer( a , b )
  first, second, array = [], [], []
  a.each(' '){|chunk| first << chunk.strip.to_i }
  b.each(' '){|chunk| second << chunk.strip.to_i }  
  for i in 0.upto(first.length-1)
    sum = first[i] + second[i]
    array << (sum - (sum>26 ? 26 : 0)).to_s
  end
  output = array.join(' ').gsub(' 0',' ')
end

def number_lesser( a , b )
  first, second, array = [], [], []
  a.each(' '){|chunk| first << chunk.strip.to_i }
  b.each(' '){|chunk| second << chunk.strip.to_i }  
  for i in 0.upto(first.length-1)
    less = first[i] - second[i]
    # if both are 0, thats where a space should be, otherwise... :
    array << ((first[i]==0 and second[i]==0) ? '' : ((less + (less<1 ? 26 : 0) ).to_s))
  end
  output = array.join(' ')
end


def cipher_enc( string )
  
  message = message_maker(string)
  p "message: #{message}"
  
  keystream = keystream_maker(message.length)
  p "keystream: #{keystream}"
  
  number_message = number_encoder( message )
  p "number message: #{number_message}"
  
  number_keystream = number_encoder( keystream )
  p "number keystream: #{number_keystream}"
  
  number_encoded_message = number_summer( number_message, number_keystream )
  p "encoded message (numbers): #{number_encoded_message}"
  
  encoded_message = number_decoder( number_encoded_message )
  p "encoded message: #{encoded_message}"
  
end

def cipher_dec( message )
  
  p "message: #{message}"
  
  keystream = keystream_maker(message.length)
  p "keystream: #{keystream}"
  
  number_message = number_encoder( message )
  p "number message: #{number_message}"
  
  number_keystream = number_encoder( keystream )
  p "number keystream: #{number_keystream}"
  
  number_decoded_message = number_lesser( number_message, number_keystream )
  p "decoded message (numbers): #{number_decoded_message}"
  
  decoded_message = number_decoder( number_decoded_message )
  p "decoded message: #{decoded_message}"
  
end

  