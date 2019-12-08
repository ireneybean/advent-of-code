# It is a six-digit number.
# The value is within the range given in your puzzle input.
# Two adjacent digits are the same (like 22 in 122345).
# Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).

#
# 111111 meets these criteria (double 11, never decreases).
# 223450 does not meet these criteria (decreasing pair of digits 50).
# 123789 does not meet these criteria (no double).

# Part 2
# An Elf just remembered one more important detail: the two adjacent matching digits are not part of a larger group of matching digits.
#
# Given this additional criterion, but still ignoring the range rule, the following are now true:
#
# 112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
# 123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
# 111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).

RANGE = (264360..746325)

def could_be_it?(x)
  six_digits?(x) && has_double?(x) && increasing?(x)  
end

def could_really_be_it?(x)
  six_digits?(x) && has_isolated_double?(x) && increasing?(x)  
end

def six_digits?(x)
   # puts "testing digits"
  x.to_s.size == 6
end

def has_double?(x)
   # puts "testing double"
  x.to_s.squeeze.size < 6
end

def has_isolated_double?(x)
  # puts "testing isolated double"
  runs = []
  run = ''
  x.to_s.split('').each_with_index do |d,i|
    
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

def increasing?(x)
   # puts "testing increasing"
  prev = 0
  x.to_s.split('').each do |digit|
    return false if digit.to_i < prev
    prev = digit.to_i
  end
  true
end

puts "FOUR"    
puts could_be_it?(111111) 
puts !could_be_it?(223450)
puts !could_be_it?(123789)   

puts 
puts "FOUR B"
puts could_really_be_it?(112233)    
puts !could_really_be_it?(123444)
puts could_really_be_it?(111122)

puts

puts RANGE.to_a.count { |num| could_be_it?(num)}
puts RANGE.to_a.count { |num| could_really_be_it?(num)}