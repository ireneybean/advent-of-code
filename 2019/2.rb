# An Intcode program is a list of integers separated by commas (like 1,0,0,3,99). To run one, start by looking at 
# the first integer (called position 0). Here, you will find an opcode - either 1, 2, or 99. The opcode indicates
#  what to do; for example, 99 means that the program is finished and should immediately halt. Encountering an 
# unknown opcode means something went wrong.

# Opcode 1 adds together numbers read from two positions and stores the result in a third position. The three 
# integers immediately after the opcode tell you these three positions - the first two indicate the positions 
# from which you should read the input values, and the third indicates the position at which the output 
# should be stored.

# Opcode 2 works exactly like opcode 1, except it multiplies the two inputs instead of adding them. Again, 
# the three integers after the opcode indicate where the inputs and outputs are, not their values.

# Once you're done processing an opcode, move to the next one by stepping forward 4 positions.
require './lib/common.rb'
require './lib/intcode_program.rb'



def test_intcode(input)
  program = Intcode::Program.new(input)
  program.run 
  program.memory 
end

AdventOfCode::test([2,0,0,0,99]) { test_intcode([1,0,0,0,99]) }
AdventOfCode::test([2,3,0,6,99]) { test_intcode([2,3,0,3,99])  }
AdventOfCode::test([2,4,4,5,99,9801]) { test_intcode([2,4,4,5,99,0]) }
AdventOfCode::test([30,1,1,4,2,5,6,0,99]) { test_intcode([1,1,1,4,99,5,6,0,99]) }


intcode = AdventOfCode::inputs(2).first.split(',').map!(&:to_i)
output = 0
noun = -1
while output != 19690720 && noun < 100
  noun = noun + 1
  intcode[1] = noun
  verb = -1
  while output != 19690720 && verb < 100 do
    verb = verb + 1
    intcode[2] = verb

    program = Intcode::Program.new(intcode)
    output = begin
      program.run
    rescue => e
      puts e
      program.memory[0]
    end
  end
end

if output == 19690720
  puts 100 * noun +  verb
else
  puts "didn't find it"
end




  