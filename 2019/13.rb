require 'minitest'
require './lib/common.rb'
require './lib/intcode_program'

class DayThirteen < Minitest::Test

  def test_tile_type?
    assert Tile.new(0, 0, 0).type?(:empty)
    assert Tile.new(0, 0, 1).type?(:wall)
    assert Tile.new(0, 0, 2).type?(:block)
    assert Tile.new(0, 0, 3).type?(:paddle)
    assert Tile.new(0, 0, 4).type?(:ball)
  end

  def test_tile
    t = Tile.new(1, 2, 3)
    assert t.type?(:paddle)
    assert_equal [1, 2], t.position
  end

  def test_tiles_from_array
    fake_output = [1, 2, 3, 6, 5, 4]
    assert_equal [[1, 2, 3], [6, 5, 4]], fake_output.each_slice(3).to_a
  end
end

class ArcadeCabinet
  attr_reader :tiles, :joystick, :score


  def initialize(program_code)
    @joystick       = Queue.new
    @score          = 0
    @program        = Intcode::Program.new(program_code)
    @program.inputs = @joystick
    @tiles = make_tiles(@program.run)
  end

  def make_tiles(tiles)
    tiles.split(',').each_slice(3).to_a.map do |tile_data|
      if tile_data[0].to_i == -1 && tile_data[1].to_i == 0
        @score = tile_data[2]
      else
        Tile.new(*tile_data)
      end
    end
  end

  def count_tiles(type = nil)
    return @tiles.size unless type

    @tiles.count { |tile| tile.type?(type) }
  end
end

class HackedArcadeCabinet < ArcadeCabinet
  def initialize(program_code)
    program_code[0] = 2
    super(program_code)
  end
end

class Tile
  TYPES = { empty: 0, wall: 1, block: 2, paddle: 3, ball: 4 }
  attr_reader :position

  def initialize(x_pos, y_pos, block_type)
    #puts "new tile: #{x_pos}, #{y_pos}, #{block_type}"
    @position   = [x_pos, y_pos]
    @block_type = TYPES.find { |key, val| val == block_type.to_i }
    raise "No such type #{block_type}" if @block_type.nil?
  end

  def type?(type)
    @block_type[0] == type
  end
end

GAME_CODE = AdventOfCode::intcode_from_file(13)
puts "Part 1 Answer is: #{ArcadeCabinet.new(GAME_CODE).count_tiles(:block)}"

#free_game = HackedArcadeCabinet.new(GAME_CODE)

#puts "Part 2 Answer is: #{free_game.score}"