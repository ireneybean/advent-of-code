class MoonSystem
  attr_reader :moons

  def initialize(moons)
    @moons = moons
  end

  def advance_time(i)
    i.times.with_index do |index|
      apply_gravity
      moons.each(&:update_position)
      puts "AFTER #{index} STEPS, #{energy}"
      puts @moons.map {|moon| moon.to_s}
    end
    puts "TOTAL ENERGY: #{energy}"
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
  attr_accessor :pos_x, :pos_y, :pos_z, :vel_x, :vel_y, :vel_z

  def initialize(x:, y:, z:)
    @pos_x = x
    @pos_y = y
    @pos_z = z
    @vel_x = @vel_y = @vel_z = 0
  end

  #
  # To apply gravity, consider every pair of moons. On each axis (x, y, and z), the velocity of each moon changes by
  # exactly +1 or -1 to pull the moons together. For example, if Ganymede has an x position of 3, and Callisto has a x
  # position of 5, then Ganymede's x velocity changes by +1 (because 5 > 3) and Callisto's x velocity changes by -1
  # (because 3 < 5). However, if the positions on a given axis are the same, the velocity on that axis does not change
  # for that pair of moons.
  def apply_gravity(other_moon)
    apply_gravity_x(other_moon)
    apply_gravity_y(other_moon)
    apply_gravity_z(other_moon)
  end

  def calculate_gravity_modifier(other, mine)
    return 0 if other == mine
    (other - mine).positive? ? 1 : -1
  end

  def apply_gravity_x(other_moon)
    delta_x = calculate_gravity_modifier(other_moon.pos_x, pos_x)
    self.vel_x = vel_x + delta_x
    other_moon.vel_x = other_moon.vel_x - delta_x
  end


  def apply_gravity_y(other_moon)
    delta_y = calculate_gravity_modifier(other_moon.pos_y, pos_y)
    self.vel_y = vel_y + delta_y
    other_moon.vel_y = other_moon.vel_y - delta_y
  end

  def apply_gravity_z(other_moon)
    delta_z = calculate_gravity_modifier(other_moon.pos_z, pos_z)
    self.vel_z = vel_z + delta_z
    other_moon.vel_z = other_moon.vel_z - delta_z
  end

  # simply add the velocity of each moon to its own position. For example, if Europa has a position of x=1, y=2, z=3
  # and a velocity of x=-2, y=0,z=3, then its new position would be x=-1, y=2, z=6. This process does not modify
  # the velocity of any moon.
  def update_position
    @pos_x = @pos_x + @vel_x
    @pos_y = @pos_y + @vel_y
    @pos_z = @pos_z + @vel_z
  end

  # total energy for a single moon is its potential energy multiplied by its kinetic energy.
  def total_energy
    potential_energy * kinetic_energy
  end

  # A moon's potential energy is the sum of the absolute values of its x, y, and z position coordinates.
  def potential_energy
    @pos_x.abs + @pos_y.abs + @pos_z.abs
  end

  def to_s
    "pos=<x= #{pos_x}, y=#{pos_y}, z=#{pos_z}>, vel=< x=#{@vel_x}, y=#{@vel_y}, z=#{@vel_z}>"
  end

  # A moon's kinetic energy is the sum of the absolute values of its velocity coordinates.
  def kinetic_energy
    @vel_x.abs + @vel_y.abs + @vel_z.abs
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
moons.advance_time(1000)


