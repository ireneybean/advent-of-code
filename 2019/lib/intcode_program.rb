module Intcode
  class Opcode
    attr_reader :size
    
    def initialize(opcode)
      parse_instruction(opcode)
      case @code
      when 1,2
        @size = 4
      when 3,4  
        @size = 2
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
      when 3
        user_input = 1
        program.store(user_input)
      when 4
        program.output    
      when 99
        program.done = true
      end
    end  
    
    private 
    
    def parse_instruction(code)
      full_code = "%05d" % code
      @code = full_code[3,2].to_i
      @param_modes = full_code[0, 3].split('').map(&:to_i).reverse
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
      @current_opcode = Opcode.new(self.memory[self.position])
      @current_opcode.run(self)

    end
  
    def add
      self.memory[write_position] = val_at(1) + val_at(2)
    end
  
    def multiply
      self.memory[write_position] = val_at(1) * val_at(2)
    end  
    
    def store(input)
      self.memory[write_position] = input
    end
    
    def output
      puts "Output: #{self.memory[write_position]}"
    end
    
    private
  
    def val_at(num)
      position = self.memory[self.position + num]
      self.memory[position]
    end

    def write_position
      self.memory[self.position + @current_opcode.size - 1]
    end 
    
    def advance
      self.position = self.position + @current_opcode.size
    end  
           
  end
end