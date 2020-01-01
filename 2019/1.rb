require './lib/common.rb'

# Fuel required to launch a given module is based on its mass. 
# Specifically, to find the fuel required for a module, 
# take its mass, divide by three, round down, and subtract 2.

def fuel_for_mass(mass)
  fuel = mass.to_i/3 - 2
  return 0 unless fuel.positive?
  
  fuel + fuel_for_mass(fuel)
end

AdventOfCode::test(2) { fuel_for_mass(14) }
AdventOfCode::test(966) { fuel_for_mass(1969) }
AdventOfCode::test(50346) { fuel_for_mass(100756) }

masses = AdventOfCode::inputs(1)
total_fuel_required = 0
masses.each { |mass|  total_fuel_required += fuel_for_mass(mass) }

puts "Answer: #{total_fuel_required}"  