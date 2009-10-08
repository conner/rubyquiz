#!/usr/bin/env ruby

# @author = Conner Peirce
# http://rubyquiz.com quiz #14

class LCDNumber
  ON = true
  OFF = false
  MAPPINGS = {
    
    0 => [ON,   ON,   ON,   OFF,  ON,   ON,  ON],
    1 => [OFF,  OFF,  ON,   OFF,  OFF,  ON,  OFF],
    2 => [ON,   OFF,   ON,  ON,   ON,  OFF,  ON],
    3 => [ON,   OFF,   ON,  ON,   OFF,   ON, ON],
    4 => [OFF,  ON,   ON,   ON,   OFF,  ON,  OFF],
    5 => [ON,   ON,   OFF,  ON,   OFF,  ON,  ON],
    6 => [ON,   ON,   OFF,   ON,  ON,   ON,  ON],
    7 => [ON,   ON,   OFF,   OFF,  ON,   OFF,  OFF],
    8 => [ON,   ON,   ON,   ON,  ON,   ON,  ON],
    9 => [ON,   ON,   ON,   ON,  OFF,   ON,  ON]
  }
  VERTICAL = [1, 2, 4, 5]
  HORIZONTAL = [0, 3, 6]
  LEFT = [1, 4]
  RIGHT = [2, 5]
  VROW = [2,4]
  
  
  
  # @number = 0
  # @size = 2
  def initialize( n = 0, size = 2 )
    # should verify one character, but presumably this will be called by class method
    # st LCDNumber.new( <0-9> ) will always be the case
    @number = n
    @size = size
    
  end

  def self.print(numbers, s=2)
    (1..5).each do |l|
      line = ""
      numbers.each_char do |nS|
        n = nS.to_i
        num = LCDNumber.new(n,s)
        line << num.printByLine(l)
        line << " " if n != 5
      end
      line << "\n"
      STDOUT << (VROW.include?(l) ? line*s : line )
    end
  end
  
  # alias for print
  def inspect
    print
  end
  
  # prints object, completes vertical scaling
  def print
    (1..5).each do |l|
      out = printByLine(l) + "\n"
      STDOUT << (VROW.include?(l) ? out*@size : out )
    end
  end
  
  # do scaling here
  def printByLine( line )
    
    if VROW.include?(line) then # scale "|"s
      if line == 2 then
        getSym(1) + " "*@size + getSym(2)
      else # line is 4
        getSym(4) + " "*@size + getSym(5)
      end
    else # scale "-"s
      sym = case line
      when 1 then getSym(0)
      when 3 then getSym(3)
      when 5 then getSym(6)
      end
      " " + sym*@size + " "
    end
  end
  
  # determines what symbol is appropriate
  def getSym( el )
    case el
    when *VERTICAL then MAPPINGS[@number][el] ? "|" : " "   
    when *HORIZONTAL then MAPPINGS[@number][el] ? "-" : " "
    end
  end
  
end


if ARGV[0] == "-s" then 
  size = ARGV[1].to_i
  numbers = ARGV[2]
else
  numbers = ARGV[0]
  size = 2
end

LCDNumber.print(numbers, size)


