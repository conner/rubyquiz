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
    @@size, @size = size
    
  end
class << self
  def print(*numbers)
    (1..5).each do |l|
      line = ""
      for n in numbers
        num = LCDNumber.new(n)
        line << num.printByLine(l)
        line << " " if n != 5
      end
      p line
      if VROW.include?(l) then
        x = @@size - 1
        x.each{ p line }
      end
    end
  end
    
end
  def print
    (1..5).each{|l| p printByLine(l)}
  end
  
  def printByLine( line )
    
    case line
    when 1 then printElement(0)
    when 2 then printElement(1) + printElement(2)
    when 3 then printElement(3)
    when 4 then printElement(4) + printElement(5)
    when 5 then printElement(6)
    end
  end
  
  def printElement( el )
    
    case el
    when *VERTICAL|LEFT
      if MAPPINGS[@number][el] then "| "
      else "  "
      end
    when *VERTICAL|RIGHT
      if MAPPINGS[@number][el] then " |"
      else "  "
      end      
    when *HORIZONTAL
      if MAPPINGS[@number][el] then " -  "
      else "    "
      end
    end
  end
end