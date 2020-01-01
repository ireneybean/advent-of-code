#!/usr/bin/env ruby
require './lib/common.rb'

class Picture
  attr_reader :layers, :width, :height

  def initialize(data, width, height)
    @height = height
    @width  = width
    @layers = split_data_into_layers(data).map { |layer_data| Layer.new(layer_data, self) }
  end

  def verification_code
    key_layer.count_digits(1) * key_layer.count_digits(2)
  end

  def render
    height.times.map { |h| render_row(h) }.join("\n")
  end

  private

  def split_data_into_layers(data)
    normalize_input(data).each_slice(height * width)
  end

  def normalize_input(input)
    input.split('').map(&:to_i)
  end

  def key_layer
    min_zero_count = min_digit_count(0)
    @key_layer     ||= layers.find { |layer| layer.count_digits(0) == min_zero_count }
  end

  def min_digit_count(digit)
    layers.map { |layer| layer.count_digits(digit) }.min
  end

  def render_row(h)
    width.times.map { |w| render_pixel(w, h) }.join('')
  end

  def render_pixel(w, h)
    return ' ' unless visible_color(w, h) == Color::WHITE

    '*'
  end

  def visible_color(w, h)
    layer_slice(w, h).find { |color| color != Color::TRANSPARENT }
  end

  def layer_slice(w, h)
    layers.map { |layer| layer.value_at(w, h) }
  end
end

class Layer
  def initialize(layer_data, picture)
    @data    = layer_data.freeze
    @picture = picture
  end

  def count_digits(digit)
    @data.count(digit)
  end

  def value_at(w, h)
    @data[index_for(w, h)]
  end

  private

  def index_for(w, h)
    h * @picture.width + w
  end
end

class Color
  BLACK       = 0.freeze
  WHITE       = 1.freeze
  TRANSPARENT = 2.freeze
end

# 8A
AdventOfCode::test(2) do
  Picture.new('123456789012', 3, 2).layers.size
end

PICTURE_DATA = AdventOfCode::inputs(8).first
puts Picture.new(PICTURE_DATA, 25, 6).verification_code

# 8B
AdventOfCode::test(" *\n* ") do
  Picture.new('0222112222120000', 2, 2).render
end

puts Picture.new(PICTURE_DATA, 25, 6).render
