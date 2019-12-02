# Fuel required to launch a given module is based on its mass. 
# Specifically, to find the fuel required for a module, 
# take its mass, divide by three, round down, and subtract 2.

def fuel_for_mass(mass)
  fuel = mass.to_i/3 - 2
  return 0 unless fuel.positive?
  
  base_fuel + fuel_for_mass(base_fuel)
end

masses = File.open('inputs/1.txt') 

total_fuel_required = 0
masses.each_line { |mass|  total_fuel_required += fuel_for_mass(mass) }

puts "Answer: #{total_fuel_required}"

# puts fuel_for_mass(14) == 2 ? 'Pass' : 'Fail'
# puts fuel_for_mass(1969) == 966 ? 'Pass' : 'Fail'
# puts fuel_for_mass(100756) == 50346 ? 'Pass' : 'Fail'