require './common.rb'
wire_paths = AdventOfCode::inputs(3).map { |path| path.split(',') } 

class Point
  attr_accessor :x, :y
  
  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end
  
  def move(dir)
    case(dir)
      when 'U'
        up
      when 'R'
        right
      when 'D'
        down
      when 'L'
        left
    end
  end  
  
  def distance_from(other)
    (x - other.x).abs + (y - other.y).abs
  end  
           
  def to_s
    "(#{x}, #{y})"
  end
  
  def inspect
    to_s
  end
  
  def ==(other)
    x == other.x && y == other.y
  end  
  
  def eql?(other)
    self == other
  end
  
  def hash
   [ x, y ].hash
  end
  
  private
  
  def up 
    Point.new(@x, @y + 1)
  end
  
  def down
    Point.new(@x, @y - 1)
  end
  
  def left
    Point.new(@x - 1, @y)
  end
  
  def right
    Point.new(@x + 1, @y)
  end  
end   

Origin = Point.new(0,0) 

class Path
  attr_reader :points

  
  def initialize(path)
    @points = []
    path.each do |follow|
      direction = follow[0]
      magnitude = follow[1..-1].to_i

      current_spot = @points.last || Point.new
      # puts "starting at #{current_spot}, move #{magnitude} #{direction}"
      magnitude.times do 
        current_spot = current_spot.move(direction)
        @points.push(current_spot)
      end  
    end
  end
  
  def step_count(point)
    @points.find_index(point) + 1
  end
  
  def intersection(other)
    points & other.points
  end  
end  

class Panel
  attr_reader :wire_1, :wire_2, :origin
  
  def initialize(input)
    @origin = Point.new
    @wire_1 = Path.new(input[0])
    @wire_2 = Path.new(input[1])
  end  
  
  def intersections
    wire_1.intersection(wire_2)
  end
  
  def min_step_distance
    intersections.map{ |p| wire_1.step_count(p) + wire_2.step_count(p) }.min
  end  
  
  def min_distance_from_origin
    intersections.map{ |p| p.distance_from(Origin)}.min
  end
  
end  
    

def test_as_the_crow_flies(input, expected)
  puts Panel.new(input).min_distance_from_origin == expected ? 'Pass' : 'Fail'
end

test_as_the_crow_flies [%w[R8 U5 L5 D3], %w[U7 R6 D4 L4]], 6
test_as_the_crow_flies [%w[R75 D30 R83 U83 L12 D49 R71 U7 L72],%w[U62 R66 U55 R34 D71 R55 D58 R83]], 159

puts "distance of closest as the crow flies: #{Panel.new(wire_paths).min_distance_from_origin}"
puts "-------\n"

def test_steps(input, expected)
  closest = Panel.new(input).min_step_distance
  puts  closest == expected ? 'Pass' : 'Fail'
end


test_steps [%w[R75 D30 R83 U83 L12 D49 R71 U7 L72],%w[U62 R66 U55 R34 D71 R55 D58 R83]], 610
test_steps [%w[R98 U47 R26 D63 R33 U87 L62 D20 R33 U53 R51], %w[U98 R91 D20 R16 D67 R40 U7 R15 U6 R7]],  410

puts "distance of closest by steps: #{Panel.new(wire_paths).min_step_distance}"
