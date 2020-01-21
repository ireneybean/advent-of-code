DEBUG = true
class MoonSystem
  attr_reader :moons

  def initialize(moons)
    @moons = moons
  end

  def fast_forward(i)
    i.times.with_index do |index|
      apply_gravity
      moons.each(&:update_position)
      puts "AFTER #{index} STEPS, #{energy}" if DEBUG
      puts @moons.map {|moon| moon.to_s}
    end
    puts "TotalEnergy in the system: #{energy}"
  end

  def energy
    @moons.inject(0) { |x, moon| x + moon.total_energy }
  end

  def apply_gravity
    moons.combination(2).each do |moon_pair|
      moon_pair[0].apply_gravity(moon_pair[1])
    end
  end
end

class Moon
  attr_accessor :position, :velocity

  def initialize(x:, y:, z:)
    @position = [x, y, z]
    @velocity = [0, 0, 0]
  end

  #
  # To apply gravity, consider every pair of moons. On each axis (x, y, and z), the velocity of each moon changes by
  # exactly +1 or -1 to pull the moons together. For example, if Ganymede has an x position of 3, and Callisto has a x
  # position of 5, then Ganymede's x velocity changes by +1 (because 5 > 3) and Callisto's x velocity changes by -1
  # (because 3 < 5). However, if the positions on a given axis are the same, the velocity on that axis does not change
  # for that pair of moons.
  def apply_gravity(other_moon)
    (0..2).to_a.each {|axis| apply_gravity_to_axis(axis, other_moon) }
  end

  def calculate_gravity_modifier(other, mine)
    return 0 if other == mine
    (other - mine).positive? ? 1 : -1
  end

  def apply_gravity_to_axis(axis, other_moon)
    delta = calculate_gravity_modifier(other_moon.position[axis], position[axis])
    self.velocity[axis] = velocity[axis] + delta
    other_moon.velocity[axis] = other_moon.velocity[axis] - delta
  end




  # simply add the velocity of each moon to its own position. For example, if Europa has a position of x=1, y=2, z=3
  # and a velocity of x=-2, y=0,z=3, then its new position would be x=-1, y=2, z=6. This process does not modify
  # the velocity of any moon.
  def update_position
    (0..2).to_a.each {|axis| position[axis] = position[axis] + velocity[axis] }
  end

  # total energy for a single moon is its potential energy multiplied by its kinetic energy.
  def total_energy
    potential_energy * kinetic_energy
  end

  # A moon's potential energy is the sum of the absolute values of its x, y, and z position coordinates.
  def potential_energy
    position.inject(0) {|sum, p| sum + p.abs  }
  end

  def to_s
    "pos=<x= #{position[0]}, y=#{position[1]}, z=#{position[2]}>, vel=< x=#{velocity[0]}, y=#{velocity[1]}, z=#{velocity[2]}>"
  end

  # A moon's kinetic energy is the sum of the absolute values of its velocity coordinates.
  def kinetic_energy
    velocity.inject(0) {|sum, v| sum + v.abs  }
  end
end

io       = Moon.new(x: -16, y: 15, z: -9)
europa   = Moon.new(x: -14, y: 5, z: 4)
ganymede = Moon.new(x: 2, y: 0, z: 6)
callisto = Moon.new(x: -3, y: 18, z: 9)
#io       = Moon.new(x: -1, y: 0, z: 2)
#europa   = Moon.new(x: 2, y: -10, z: -7)
#ganymede = Moon.new(x: 4, y: -8, z: 8)
#callisto = Moon.new(x: 3, y: 5, z:-1)

moons = MoonSystem.new([io, europa, ganymede, callisto])
puts moons.moons.map(&:to_s)
moons.fast_forward(1000)


