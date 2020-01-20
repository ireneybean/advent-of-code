#!/usr/bin/env ruby

require './lib/common.rb'

class AsteroidMap
  attr_reader :asteroids

  def initialize(map_data)
    @height    = map_data.size
    @width     = map_data.first.size
    @asteroids = map_data.collect.with_index do |row, rowdex|
      row.split('').collect.with_index do |sector_data, coldex|
        Asteroid.new(coldex, rowdex, self) if sector_data == '#'
      end.compact
    end.flatten
  end

  def station
    #@station ||= asteroids.max_by { |asteroid| asteroid.visible_asteroids.count }
    asteroids.find{|asteroid| asteroid.x == 11 && asteroid.y ==13}
  end

  def render_picture
    buffer = Array.new(@height) { Array.new(@width, '[      ]') }
    asteroids.each do |a|

      #buffer[a.y][a.x] = "[#{a.coordinates.map{|x| sprintf '%02d', x }.join(',')}]"
      line_of_sight = station.line_of_sight(a)
      buffer[a.y][a.x] = "[#{line_of_sight[0]},#{sprintf '%0.2f', line_of_sight[1]}]" unless a==station
      buffer[a.y][a.x] = "[******]" if a==station
    end
    buffer.map { |row| row.join('') }.join("\n")
  end

  def exterminate_asteroids_from(station)

    while (asteroids - [station]).any? do
      lines = sight_lines_from(station)
      #puts lines.map {|s,v| "#{s}:#{v.size}" }.join("\n")
      lines.keys.sort_by do |slope|
        [slope.slice(0).to_i, slope.slice(1..-1).to_f]
      end.each do |slope|
        puts "slope #{slope}"
        vaporize_asteroid(station.closest(lines[slope]))
      end
    end
  end

  def sight_lines_from(station)
    asteroids.each_with_object({}) do |asteroid, slopes|
      slope = station.line_of_sight(asteroid).join
      slopes[slope] ||= []
      slopes[slope] << asteroid
    end
  end

  def vaporize_asteroid(asteroid)
    return unless asteroid
    puts "vaporizing #{vaporization_history.count+1} #{asteroid.coordinates.join(',')}"
    @asteroids.delete(asteroid)
    vaporization_history << asteroid
    #puts render_picture
  end

  def vaporization_history
    @vaporization_history ||= []
  end
end

class Asteroid
  attr_reader :coordinates

  def initialize(x, y, map)
    @map         = map
    @coordinates = [x, y]
  end

  def x
    coordinates[0]
  end

  def y
    coordinates[1]
  end

  def visible_asteroids
    @visibles ||= @map.asteroids.select { |asteroid| visible_from_here?(asteroid) }
  end

  def slope_for_angle(degrees)
    return 0 if degrees == 0
    (Math.tan(degrees * Math::PI / 180 ))
  end

  def closest(asteroids)
    asteroids.min_by { |asteroid| distance_from(asteroid) }
  end

  def distance_from(other)
    a = y - other.y
    b = x - other.x
    c_squared = (a * a) + (b * b)
    Math.sqrt(c_squared)
  end

  def visible_from_here?(other)
    return false if coordinates == other.coordinates

    @map.asteroids.none? do |asteroid|
      asteroid.blocks_view?(self, other)
    end
  end

  def blocks_view?(station, other_asteroid)
    return false if [station, other_asteroid].include?(self)

    aligned_with?(station, other_asteroid) && between?(station, other_asteroid)
  end

  def aligned_with?(station, other_asteroid)
    station.line_of_sight(self) == station.line_of_sight(other_asteroid)
  end

  def between?(station, other_asteroid)
    coord_between(station, other_asteroid, 0) && coord_between(station, other_asteroid, 1)
  end

  def line_of_sight(other)
    delta_y =  (other.y - y)
    delta_x = (other.x - x)
    quadrant = %w(+- ++ -+ --).find_index((x <= other.x ? '+' : '-') + (y <= other.y ? '+' : '-'))
    return [quadrant, 0] if delta_x.zero?
    [quadrant,(delta_y.to_f / delta_x.to_f)]
  end

  def coord_between(first_asteroid, second_asteroid, idx)
    limits = [first_asteroid.coordinates[idx], second_asteroid.coordinates[idx]]
    return true if [limits, coordinates[idx]].flatten.uniq.size == 1

    coordinates[idx] > limits.min && coordinates[idx] < limits.max
  end
end

#AdventOfCode::test(8) do
#  map = AsteroidMap.new(%w(.#..# ..... ##### ....# ...##))
#  map.station.visible_asteroids.count
#end
#
#AdventOfCode::test(33) do
#  map = AsteroidMap.new(%w(......#.#. #..#.#.... ..#######. .#.#.###.. .#..#..... ..#....#.# #..#....#. .##.#..### ##...#..#. .#....####))
#  map.station.visible_asteroids.count
#end
#
#AdventOfCode::test(35) do
#  map = AsteroidMap.new(%w(#.#...#.#. .###....#. .#....#... ##.#.#.#.# ....#.#.#. .##..###.# ..#...##.. ..##....## ......#... .####.###.))
#  map.station.visible_asteroids.count
#end


MAP = AdventOfCode::inputs(10)
map = AsteroidMap.new(MAP)
#puts "Day 10, part 1: Calculating best place for a station"
#station = map.station
#puts "best station is at #{station.coordinates} and can see #{station.visible_asteroids.count}"

station = map.asteroids.find { |a| a.coordinates == [20, 18] }
puts map.render_picture
map.exterminate_asteroids_from(station)
puts "200th destroyed is #{map.vaporization_history[199]&.coordinates.inspect}"