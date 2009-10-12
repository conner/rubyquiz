#!/usr/bin/env ruby

# @author = Conner Peirce
# http://rubyquiz.com quiz #15


class AniNode
  @query
  attr_reader :leftNode, :rightNode, :animal
  @@root = nil
  @@current = nil
  
  def initialize( animal )
    @animal = animal
    @leftNode, @rightNode = nil
  end
  
  def isLeaf?; @leftNode.nil? && @rightNode.nil?; end
  
  def inspect; @animal ? @animal : @query; end
  
  # pokes our node, returns nodes prompt (either from query or animal)
  def poke
    
    STDOUT << if @animal then "Is it an #{@animal}? "
    elsif @query then @query
    else # throw exception here
    end
  end
  
  def insertNode(query, yesNode, noNode)
    @animal = nil
    @query = query
    @rightNode = yesNode
    @leftNode = noNode
    
  end
  def self.begin
    @@root = AniNode.new( "elephant" )
    @@current = @@root
  end
  
  
  def self.build
    
    STDOUT <<   "You Win!\nWhat was the animal?\n"
    animal = gets.chomp
    STDOUT << "A question to distinguish it from a #{AniNode.current.animal}"
    query = gets.chomp
    
    STDOUT << "For #{animal}, what is the answer to your question?" # make sure yes or no
    answer = gets.chomp.to_sym
    
    @@current.insertNode(query, AniNode.new(animal), AniNode.new(@@current.animal)) if answer == :yes
    @@current.insertNode(query, AniNode.new(@@current.animal), AniNode.new(animal)) if answer == :no
    
    self.reset
    
  end
  
  def self.yes?; !@@current.rightNode.nil?; end
  def self.no?; !@@current.leftNode.nil?; end
  def self.yes;  @@current = @@current.rightNode;  end
  def self.no; @@current = @@current.leftNode; end
  def self.current; @@current;  end
  def self.poke;    @@current.poke;  end
  def self.reset; @@current = @@root; end
  private
  
  #attr_accessor :leftNode, :rightNode
  
end

# put opening logic in a 'begin' method
AniNode.begin

puts "Think of an animal..."

while true do
  
  AniNode.poke
  response = gets.chomp
  p response
  case response
  when "yes"
    if AniNode.yes? then AniNode.yes
    else
      STDOUT << "I Win!\n"
      AniNode.reset
      # play again bullshit promprt
      
    end
  when "no"
    if AniNode.no? then AniNode.no
    else
      AniNode.build
      
      # what was the animal
      # what question, is it yes or no
    end
  when "quit" 
    STDOUT << "Thanks for playing!"
    break
  end

end

#if AniNode.root then end
