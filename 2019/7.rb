require './lib/common.rb'
require './lib/intcode_program.rb'

INTCODE = AdventOfCode::inputs(7).first.split(',').map(&:to_i).freeze


def try_phase_setting(phase,intcode)
  record_output=[]

  (0..4).to_a.each do |num|
    input_chain ||= 0
    input_chain = Intcode::Program.new(intcode.dup, [phase[num].to_i, input_chain]).run
    record_output << input_chain
  end  
  record_output.join
end

def find_max(program)
  outputs = []
  [0,1,2,3,4].permutation.max_by do |permutation|
    last_output = 0
    [0,1,2,3,4].each do |i| 
      last_output = Intcode::Program.new(program.dup, [permutation[i], last_output]).run
    end
    outputs << last_output
  end
  outputs.max
end

AdventOfCode::test(43210) do
  test_1 = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
  find_max(test_1)
end

AdventOfCode::test(54321) do
  test_2 = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
  find_max(test_2)
end

AdventOfCode::test(65210) do
  test_3 = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
  find_max(test_3)
end

puts "7A: The highest signal that can be sent to the thrusters is: #{find_max(INTCODE)}"

