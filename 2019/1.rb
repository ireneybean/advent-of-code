# Fuel required to launch a given module is based on its mass. 
# Specifically, to find the fuel required for a module, 
# take its mass, divide by three, round down, and subtract 2.

masses = File.open('inputs/1.txt') 

total_fuel_required = 0
masses.each_line { |mass|  total_fuel_required += (mass.to_i/3 - 2) }

puts "Answer: #{total_fuel_required}"