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
class IntcodeProgram
  attr_accessor :done, :memory, :position

  def initialize(intcode)
    @memory = intcode.clone
    @done = false
    @position = 0
  end
  
  def run
    while !done
      do_opcode
      self.position = self.position + @hopsize
    end  
    self.memory[0]
  end
  
  def do_opcode
    # puts "processing opcode at: #{position}: #{self.memory[self.position]}"
    case opcode
    when 1
      @hopsize = 4
      add
      # puts "add #{self.memory[a1_position]} to #{self.memory[a2_position]}"
    when 2
      @hopsize = 4
      multiply
    when 99
      @hopsize = 1
      self.done = true
    else
      # puts self.memory.join(',')
      raise "Something has gone wrong, input at #{self.position} is #{self.memory[self.position]}"
    end
  end
  
  def add
    self.memory[write_position] = val(1) + val(2)
  end
  
  def multiply
    self.memory[write_position] = val(1) * val(2)
  end  
  
  private
  
  def opcode
    self.memory[self.position]
  end
  
  def val(num)
    position = self.memory[self.position + num]
    self.memory[position]
  end

  def write_position
    self.memory[self.position + 3]
  end      
end



def test_intcode(input, expected)
  program = IntcodeProgram.new(input)
  program.run 
  puts program.memory == expected ? 'Pass' : 'Fail'
end

test_intcode([1,0,0,0,99], [2,0,0,0,99])
test_intcode([2,3,0,3,99], [2,3,0,6,99])
test_intcode([2,4,4,5,99,0], [2,4,4,5,99,9801])
test_intcode([1,1,1,4,99,5,6,0,99], [30,1,1,4,2,5,6,0,99])

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

    program = IntcodeProgram.new(intcode)
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




  