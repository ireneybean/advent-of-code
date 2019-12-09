require './lib/common.rb'
require './lib/intcode_program.rb'

intcode = AdventOfCode::inputs(5).first.split(',').map!(&:to_i)

Intcode::Program.new(intcode,1).run


puts
puts "5B"

test_in = [3,9,8,9,10,9,4,9,99,-1,8]
AdventOfCode::test(1) do
  program = Intcode::Program.new(test_in, 8)
  program.run
  program.outputs.first
end

AdventOfCode::test(0) do
  program = Intcode::Program.new(test_in, 3)
  program.run
end

test_in = [3,9,7,9,10,9,4,9,99,-1,8]
AdventOfCode::test(1) do
  program = Intcode::Program.new(test_in, 7)
  program.run
end

AdventOfCode::test(0) do
  program = Intcode::Program.new(test_in, 8)
  program.run
end

AdventOfCode::test(0) do
  program = Intcode::Program.new(test_in, 9)
  program.run
end


test_in = [3,3,1108,-1,8,3,4,3,99]
AdventOfCode::test(1) do
  program = Intcode::Program.new(test_in, 8)
  program.run
end

AdventOfCode::test(0) do
  program = Intcode::Program.new(test_in, 3)
  program.run
end


test_in = [3,3,1107,-1,8,3,4,3,99]
AdventOfCode::test(1) do
  program = Intcode::Program.new(test_in, 7)
  program.run
end

AdventOfCode::test(0) do
  program = Intcode::Program.new(test_in, 8)
  program.run
end

AdventOfCode::test(0) do
  program = Intcode::Program.new(test_in, 9)
  program.run
end


test_in = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]

AdventOfCode::test(0) do
  program = Intcode::Program.new(test_in, 0)
  program.run 
end
AdventOfCode::test(1) do
  program = Intcode::Program.new(test_in, 1)
  program.run
end

AdventOfCode::test(1) do
  program = Intcode::Program.new(test_in, 2)
  program.run
end

AdventOfCode::test(1) do
  program = Intcode::Program.new(test_in, -1)
  program.run
end

test_in = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]
AdventOfCode::test(0) do
  program = Intcode::Program.new(test_in, 0)
  program.run
end

AdventOfCode::test(1) do
  program = Intcode::Program.new(test_in, 1)
  program.run
end

AdventOfCode::test(1) do
  program = Intcode::Program.new(test_in, 2)
  program.run
end

AdventOfCode::test(1) do
  program = Intcode::Program.new(test_in, -1)
  program.run
end

test_in = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]

AdventOfCode::test(999) do
  program = Intcode::Program.new(test_in, 7)
  program.run
  program.outputs.first
end

AdventOfCode::test(1000) do
  program = Intcode::Program.new(test_in, 8)
  program.run
  program.outputs.first
end

AdventOfCode::test(1001) do
  program = Intcode::Program.new(test_in, 9)
  program.run
  program.outputs.first
end

puts "Getting code for System 5"
Intcode::Program.new(intcode, 5).run