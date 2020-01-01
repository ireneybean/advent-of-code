require './lib/common.rb'

class OrbitMap
  def initialize(orbit_data)
    @bodies_in_space = {}

    orbit_data.each do |datum|
      orbitee, orbiter = datum.split(')').map(&:chomp)
      @bodies_in_space[orbiter] = orbitee
    end  
  end
  
  def orbiters 
    @bodies_in_space.keys
  end
  
  def count
    orbiters.map {|body| find_orbits(body).length }.sum
  end
  
  def orbitee_of(orbiter)
    return nil unless @bodies_in_space.key?(orbiter)
    
    @bodies_in_space[orbiter]
  end
  
  def orbital_transfers(orbiter_1, orbiter_2)
    o1 = find_orbits(orbitee_of(orbiter_1))
    o2 = find_orbits(orbitee_of(orbiter_2))
    ((o1 + o2) - (o1 & o2)).length
  end
  
  private
  
  def find_orbits(orbiter)
    orbitee = orbitee_of(orbiter)
    return [] unless orbitee
    
    find_orbits(orbitee) << orbiter
  end
end



test_map = OrbitMap.new(['COM)B','B)C','C)D','D)E','E)F','B)G','G)H','D)I','E)J','J)K','K)L'])
AdventOfCode::test(42) { test_map.count }
map = OrbitMap.new(AdventOfCode::inputs(6))
puts "Total orbits #{map.count}"

test_map=OrbitMap.new(['COM)B','B)C','C)D','D)E','E)F','B)G','G)H','D)I','E)J','J)K','K)L','K)YOU','I)SAN'])

AdventOfCode::test(4) { test_map.orbital_transfers('YOU', 'SAN') }
puts "Orbital transfers between Santa and I: #{map.orbital_transfers('YOU', 'SAN')}"