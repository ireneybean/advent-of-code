module Intcode
  class Opcode
    attr_reader :size
    def initialize(opcode)
      @code = opcode
      case @code
      when 1
        @size = 4
      when 2
        @size = 4
      when 99
        @size = 1
      else
        # puts self.memory.join(',')
        raise "Something has gone wrong, input is #{opcode}"
      end
    end
    
    def run(program)
      case @code
      when 1
        program.add
      when 2
        program.multiply
      when 99
        program.done = true
      end
    end  
  end   
   
  class Program
    attr_accessor :done, :memory, :position

    def initialize(intcode)
      @memory = intcode.clone
      @done = false
      @position = 0
    end
  
    def run
      while !done
        do_next_instruction
        advance
      end  
      self.memory[0]
    end
  
    def do_next_instruction
      # puts "processing opcode at: #{position}: #{self.memory[self.position]}"
      current_opcode = Opcode.new(self.memory[self.position])
      current_opcode.run(self)
      @hopsize = current_opcode.size
    end
  
    def add
      self.memory[write_position] = val(1) + val(2)
    end
  
    def multiply
      self.memory[write_position] = val(1) * val(2)
    end  
    private
  
    def val(num)
      position = self.memory[self.position + num]
      self.memory[position]
    end

    def write_position
      self.memory[self.position + 3]
    end 
    
    def advance
      self.position = self.position + @hopsize
    end  
           
  end
end