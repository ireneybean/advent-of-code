DEBUG = true

class MoonSystemTimeSimulator
  attr_reader :moon_system

  def initialize(moon_system_in)
    @moon_system       = moon_system_in
    @initial_positions = moon_system_in.moons.map { |moon| moon.position.dup }
  end

  def reset
    new_moons = @initial_positions.map { |pos| Moon.new(*pos)}
    @moon_system = MoonSystem.new(new_moons)
  end

  def fast_forward_till(i)
    output_state(0)
    i.times.with_index do |index|
      moon_system.step_forward
      output_state(index + 1)
    end

    total_energy = moon_system.energy
    puts "\nTotalEnergy in the system: #{total_energy}"
    total_energy
  end

  def predict_deja_vu
    MoonSystem::AXES.map { |axis| first_repeat(axis) }.inject(1, :lcm)
  end

  private

  def first_repeat(axis)
    i = 1
    loop do
      #print "#{i} " if i % 100_000 == 0
      moon_system.step_forward_axis(axis)
      return i if deja_vu?(axis)

      i += 1
    end
  end

  def deja_vu?(axis)
    moon_system.velocities_by_axis(axis).all? { |v| v.zero? } &&
        moon_system.positions_by_axis(axis) == @initial_positions.map { |position| position[axis] }
  end

  def output_state(steps = nil)
    return unless DEBUG
    message = "#{moon_system.to_s}\nEnergy: #{moon_system.energy}"
    message = "\nAFTER #{steps} STEPS: \n" + message if steps
    puts message
  end
end

class MoonSystem
  AXES = [0, 1, 2]
  attr_reader :moons

  def initialize(moons)
    @moons = moons
  end

  def step_forward
    AXES.each do |axis|
      step_forward_axis(axis)
    end
  end

  def step_forward_axis(axis)
    apply_gravity_to_axis(axis)
    moons.each { |moon| moon.update_position_for_axis(axis) }
  end

  def energy
    moons.inject(0) { |x, moon| x + moon.total_energy }
  end

  def apply_gravity_to_axis(axis)
    moons.combination(2).each do |moon_pair|
      moon_pair[0].apply_gravity_to_axis(axis, moon_pair[1])
    end
  end

  def velocities_by_axis(axis)
    moons.map { |moon| moon.velocity[axis] }
  end

  def positions_by_axis(axis)
    moons.map { |moon| moon.position[axis] }
  end

  def to_s
    moons.map(&:to_s).join("\n")
  end
end

class Moon
  attr_accessor :position, :velocity, :axes

  def initialize(x, y, z)
    @position = [x, y, z]
    @velocity = [0, 0, 0]
  end

  # total energy for a single moon is its potential energy multiplied by its kinetic energy.
  def total_energy
    potential_energy * kinetic_energy
  end

  def to_s
    "pos=<x= #{position[0]}, y=#{position[1]}, z=#{position[2]}>, vel=< x=#{velocity[0]}, y=#{velocity[1]}, z=#{velocity[2]}>"
  end

  def apply_gravity_to_axis(axis, other_moon)
    delta                     = calculate_gravity_modifier(other_moon.position[axis], position[axis])
    self.velocity[axis]       = velocity[axis] + delta
    other_moon.velocity[axis] = other_moon.velocity[axis] - delta
  end

  def update_position_for_axis(axis)
    position[axis] = position[axis] + velocity[axis]
  end

  private

  def calculate_gravity_modifier(other, mine)
    return 0 if other == mine
    (other - mine).positive? ? 1 : -1
  end

  # A moon's potential energy is the sum of the absolute values of its x, y, and z position coordinates.
  def potential_energy
    position.inject(0) { |sum, p| sum + p.abs }
  end

  # A moon's kinetic energy is the sum of the absolute values of its velocity coordinates.
  def kinetic_energy
    velocity.inject(0) { |sum, v| sum + v.abs }
  end
end

io       = Moon.new(-16,15, -9)
europa   = Moon.new(-14, 5, 4)
ganymede = Moon.new(2, 0,  6)
callisto = Moon.new(-3,18, 9)


moons     = MoonSystem.new([io, europa, ganymede, callisto])
simulator = MoonSystemTimeSimulator.new(moons)
part_a = simulator.fast_forward_till(1000)

puts "Answer is: #{part_a}"
puts "FAILED" if part_a != 10664

simulator.reset
part_b = simulator.predict_deja_vu

puts "Answer is: #{part_b}"
puts "FAILED" if part_b != 303459551979256

#303459551979256


