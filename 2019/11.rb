#!/usr/bin/env ruby

require './lib/common.rb'
require './lib/intcode_program.rb'

PAINT = AdventOfCode::inputs(11).first.split(',').map(&:to_i).freeze

class EmergencyHullPaintingRobot
  attr_reader :position, :direction, :panels

  def initialize(program)
    @panels    = {}
    @direction = 0
    @position  = [100, 100]
    @brains    = program
    threads    = [Thread.new { @brains.run }]
    listen_to_brains

    @panels
  end

  def listen_to_brains
    while !@brains.done
      while @brains.outputs.empty? && !@brains.done do
        sleep 0.000001
      end
      color_to_paint = @brains.outputs.pop
      puts "PAINT CURRENT PANEL #{color_to_paint}"
      paint_panel(color_to_paint)
      while @brains.outputs.empty?  && !@brains.done do
        sleep 0.00001
      end
      direction_to_turn = @brains.outputs.pop if !@brains.done
      puts "MOVE #{direction_to_turn}"
      move(direction_to_turn)

      @brains.inputs.push(read_panel_color) if !@brains.done
    end
  rescue RuntimeError => e
    puts e.message
  end

  def paint_panel(color)
    puts "PAINTING #{@position} to #{color}"
    @panels[@position.last] ||= {}
    row = @panels[@position.last]
    row[@position.first] = color
  end

  def move(left_or_right)
    turn(left_or_right)
    case direction
    when 0
      @position[1] = @position[1] - 1
    when 90
      @position[0] = @position[0] + 1
    when 180
      @position[1] = @position[1] + 1
    when 270
      @position[0] = @position[0] - 1
    end
    puts "NEW POSITION IS: #{@position.join(',')}"
  end

  def read_panel_color
    row = @panels[@position.last] ||= {}
    row.fetch(@position.first, 0)
  end

  def count_painted_squares
    painted = 0
    @panels.values.map { |row_panels| row_panels.reject {|index, color| color.nil? }.keys.uniq }.each do |painted_i|
      painted = painted +  painted_i.size
    end
    painted
  end

  def show_code
    row_min = @panels.keys.sort.min
    row_max = @panels.keys.sort.max
    col_min = @panels.values.map(&:keys).flatten.sort.min
    col_max = @panels.values.map(&:keys).flatten.sort.max
    array_col_index_offset = 0 - col_min
    rows = []

    (row_min..row_max).to_a.each do |row_index|
      cols = @panels[row_index] || {}
      columns = []
      (col_min..col_max).to_a.each do |col_index|
        columns << cols[col_index]
      end
      rows <<  columns
    end
    rows.map { |row| row.map { |panel| panel == 1 ? '*' : ' ' }.join }.join("\n")
  end

  private

  def turn(left_or_right)
    left_or_right       = -1 unless left_or_right == 1
    new_direction_index = ([0, 90, 180, 270].find_index(@direction) + left_or_right) % 4
    @direction          = [0, 90, 180, 270][new_direction_index]
    puts "NEW DIRECTION IS #{@direction}"
    @direction
  end
end

program = Intcode::Program.new(PAINT, 1, 'Robot')
robot    = EmergencyHullPaintingRobot.new(program)
puts "Number painted: #{robot.count_painted_squares}"
#puts robot.panels.inspect
puts robot.show_code


