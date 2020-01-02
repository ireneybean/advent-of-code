#!/usr/bin/env ruby

require './lib/common.rb'
require './lib/intcode_program.rb'

# Here are some example programs that use these features:
#  109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99 takes no input and produces a copy of itself as output.
#  1102,34915192,34915192,7,4,7,99,0 should output a 16-digit number. (#1219070632396864)
#  104,1125899906842624,99 should output the large number in the middle.

#test_in = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
#AdventOfCode::test('109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99') do
#  program = Intcode::Program.new(test_in, nil)
#  program.run
#end
#
#test_in = [1102,34915192,34915192,7,4,7,99,0]
#AdventOfCode::test('1219070632396864') do
#  program = Intcode::Program.new(test_in, nil)
#  program.run
#end
#
#test_in = [104,1125899906842624,99]
#AdventOfCode::test('1125899906842624') do
#  program = Intcode::Program.new(test_in, nil)
#  program.run
#end

BOOST = AdventOfCode::inputs(9).first.split(',').map(&:to_i).freeze
program = Intcode::Program.new(BOOST, 1)
puts program.run

program = Intcode::Program.new(BOOST, 2)
puts program.run
