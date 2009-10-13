#!/usr/bin/env ruby

# @author = Conner Peirce
# http://rubyquiz.com quiz #15
#---
# FIX: you can't quit if there is only one AniNode
#+++
class AniNode
  attr_reader :leftNode, :rightNode
  @@root, @@current, @data = nil
  
  def initialize( animal )
    @data = animal
    @leftNode, @rightNode = nil
  end
  
  def leaf?; @leftNode.nil? && @rightNode.nil?; end
  
  def inspect; @data; end


  def poke; STDOUT << (leaf? ? "Is it #{@data}? " : @data + " "); end
  
  def insertNode(query, yesNode, noNode)
    @data = query
    @rightNode = yesNode
    @leftNode = noNode
    
  end
  def self.begin
    @@root = AniNode.new( "an elephant" )
    @@current = @@root
  end
  
  
  def self.build
    
    STDOUT <<   "You Win!\nWhat was the animal?\n"
    animal = gets.chomp
    STDOUT << "A question to distinguish it from #{@@current.inspect}: "
    query = gets.chomp
    
    STDOUT << "For #{animal}, what is the answer to your question? " # make sure yes or no
    answer = gets.chomp.to_sym
    
    @@current.insertNode(query, AniNode.new(animal), AniNode.new(@@current.inspect)) if answer == :yes
    @@current.insertNode(query, AniNode.new(@@current.inspect), AniNode.new(animal)) if answer == :no
    
    STDOUT << "Let us play again.\n"
    self.reset
    
  end
  
  def self.leaf?; @@current.leaf?; end
  def self.yes;  @@current = @@current.rightNode;  end
  def self.no; @@current = @@current.leftNode; end
  def self.current; @@current;  end
  def self.poke;    @@current.poke;  end
  def self.reset; @@current = @@root; end
  
  def self.userWin?
    self.poke
    response = gets.chomp.to_sym
    
    response == :no
  end
end

AniNode.begin

puts "Think of an animal..."

while true do
  
  if AniNode.leaf?
    if AniNode.userWin? then AniNode.build # determine if it is their animal
    else
      STDOUT << "I Win. We play again.\n"
      AniNode.reset
    end
  else
  AniNode.poke
  
  response = gets.chomp.to_sym
  
  case response
  when :yes then AniNode.yes
  when :no then AniNode.no
  when :quit
    STDOUT << "Thanks for playing!"
    break
  end
  
end

end