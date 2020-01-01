#!/usr/bin/env ruby

require './lib/common.rb'

class Picture
  attr_reader :layers

  def initialize(data, width, height)
    @data = parse_data(data).freeze
    @width = width.freeze
    @height = height.freeze
    @layers = process_layers
  end

  def parse_data(data)
    data.split('').map(&:to_i)
  end

  def process_layers
    @layers ||= @data.each_slice( @width * @height)
  end

  def hash
    min_zero_count = @layers.map { |layer| layer.count(0) }.min
    hash_layer = @layers.find { |layer| layer.count(0) == min_zero_count }
    hash_layer.count(1) * hash_layer.count(2)
  end
end

AdventOfCode::test(2) do
  Picture.new('123456789012', 3,2).layers.size
end

PICTURE = AdventOfCode::inputs(8).first
puts Picture.new(PICTURE, 25,6).hash