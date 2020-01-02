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

  def best_asteroid
    asteroids.max
  end

  def render
    buffer = Array.new(@height) { Array.new(@width, '.') }
    asteroids.each do |a|
      #buffer[a.coordinates[1]][a.coordinates[0]] = a.visible_asteroids.map {|a|a.coordinates.inspect}.join(',')
      #buffer[a.coordinates[1]][a.coordinates[0]] = (asteroids - a.visible_asteroids - [a]).map {|a|a.coordinates.inspect}.join(';')
      buffer[a.coordinates[1]][a.coordinates[0]] = a.visible_asteroids.count
    end
    buffer.map { |row| row.join('') }.join("\n")
  end

end

class Asteroid
  include Comparable

  attr_reader :coordinates

  def initialize(x, y, map)
    @map         = map
    @coordinates = [x, y]
  end

  def <=>(other)
    visible_asteroids.count <=> other.visible_asteroids.count
  end

  def visible_asteroids
    @visibles ||= @map.asteroids.select { |asteroid| visible_from_here?(asteroid) }
  end

  def visible_from_here?(other)
    return false if coordinates == other.coordinates

    @map.asteroids.none? do |asteroid|
      asteroid.between?(self, other)
    end
  end

  def between?(station, other_asteroid)
    return false if coordinates == station.coordinates || coordinates == other_asteroid.coordinates
    coord_between(station, other_asteroid, 0) &&
        coord_between(station, other_asteroid, 1) &&
    station.line_of_sight(other_asteroid.coordinates) == station.line_of_sight(self.coordinates)
  end

  def line_of_sight(other)
    (coordinates[1] - other[1]).to_f / (coordinates[0] - other[0]).to_f
  end


  def coord_between(first_asteroid, second_asteroid, idx)
    limits = [first_asteroid.coordinates[idx], second_asteroid.coordinates[idx]]
    return true if [limits, coordinates[idx]].flatten.uniq.size == 1

    coordinates[idx] > limits.min && coordinates[idx] < limits.max
  end
end

AdventOfCode::test(8) do
  map      = AsteroidMap.new(%w(.#..# ..... ##### ....# ...##))
  map.best_asteroid.visible_asteroids.count
end

AdventOfCode::test(33) do
  map      = AsteroidMap.new(%w(......#.#. #..#.#.... ..#######. .#.#.###.. .#..#..... ..#....#.# #..#....#. .##.#..### ##...#..#. .#....####))
  map.best_asteroid.visible_asteroids.count
end

AdventOfCode::test(35) do
  map      = AsteroidMap.new(%w(#.#...#.#. .###....#. .#....#... ##.#.#.#.# ....#.#.#. .##..###.# ..#...##.. ..##....## ......#... .####.###.))
  map.best_asteroid.visible_asteroids.count
end


#MAP = AdventOfCode::inputs(10)
#map      = AsteroidMap.new(MAP)
#puts "Day 10, part 1: Calculating best place for a station"
#asteroid = map.best_asteroid
#puts "best station is at #{asteroid.coordinates} and can see #{asteroid.visible_asteroids.count}"