#!/usr/bin/env ruby

# @author = Conner Peirce
# http://rubyquiz.com quiz #2

class Player  
  attr_reader :firstname, :familyname, :email
  attr_accessor :match, :picked
  
  def initialize( string )
    tokenized = string.scan(/\S+/)
    @firstname = tokenized[0]
    @familyname = tokenized[1]
    @email = tokenized[2]
    @match = nil
    @picked = false
  end
  
  def potential_match?( player )
    !player.picked & (@familyname != player.familyname)
  end
  
  def inspect
    "\n#{@firstname} #{@familyname} #{@email} " + (@match ? " --> #{@match.firstname} #{@match.familyname} #{@match.email}" : "unmatched")
  end
end

players = []
unmatched = false
STDIN.each { |l| players << Player.new(l) }

players.each {|p| 
  match = nil
  players.each {|m| match = m if p.potential_match?(m) }
  p.match = match
  match ? match.picked = true : unmatched = true
}

p players
p "This group is hard to match - Ask another family to join!" if unmatched

#implement emailing system