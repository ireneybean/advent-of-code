require './lib/common.rb'
require './lib/intcode_program.rb'

intcode = AdventOfCode::inputs(5).first.split(',').map!(&:to_i)

class IntcodeProgramExtended < IntcodeProgram
  
  def do_opcode
    case opcode
    when 3
      @hopsize = 2
      store
    when 4
      @hopsize = 2
      output
    else 
      super
    end    
  end
end
