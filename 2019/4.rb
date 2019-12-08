# Part 1
# It is a six-digit number.
# The value is within the range given in your puzzle input.
# Two adjacent digits are the same (like 22 in 122345).
# Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
#
# 111111 meets these criteria (double 11, never decreases).
# 223450 does not meet these criteria (decreasing pair of digits 50).
# 123789 does not meet these criteria (no double).

# Part 2
# the two adjacent matching digits are not part of a larger group of matching digits.
#
# 112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
# 123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
# 111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).
require './lib/common.rb'

class MaybePassword
  def initialize(x)
    @candidate = x
  end
  
  def could_be_it?
    six_digits? && increasing? && has_double?
  end
    
  def six_digits?
    @candidate.to_s.size == 6
  end

  def has_double?
    @candidate.to_s.squeeze.size < 6
  end

  def increasing?
    prev = 0
    @candidate.to_s.split('').each do |digit|
      return false if digit.to_i < prev
      prev = digit.to_i
    end
    true
  end
end
class MaybePasswordStrict < MaybePassword
  def has_double?
    return false unless super
    
    runs = []
    run = ''
    @candidate.to_s.split('').each_with_index do |d,i|
    
      if d == run.split('').last || run == ''
        run << d
        runs.push(run) if i==5
      else
        runs.push(run)
        run = d  
      end
    end
    runs.any?{ |run| run.size == 2}    
  end
end

RANGE = (264360..746325)
puts "FOUR"    
AdventOfCode::test(true) { MaybePassword.new(111111).could_be_it? }
AdventOfCode::test(false) { MaybePassword.new(223450).could_be_it? }
AdventOfCode::test(false) { MaybePassword.new(223450).could_be_it? }  
puts RANGE.to_a.count { |num| MaybePassword.new(num).could_be_it?}

puts "FOUR B"
AdventOfCode::test(true) {  MaybePasswordStrict.new(112233).could_be_it? }
AdventOfCode::test(false) {   MaybePasswordStrict.new(123444).could_be_it? }
AdventOfCode::test(true) {   MaybePasswordStrict.new(111122).could_be_it? }
puts RANGE.to_a.count { |num|  MaybePasswordStrict.new(num).could_be_it?}