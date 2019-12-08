module Intcode
  class Opcode
    attr_reader :size
    attr_accessor :next
    
    def initialize(program)
      @program = program
      parse_instruction(program.memory[program.position])
      case @code
      when 1,2,7,8
        @size = 4
      when 3,4  
        @size = 2
      when 5,6
        @size = 3  
      when 99
        @size = 1
      else
        # puts self.memory.join(',')
        raise "Something has gone wrong, input is #{@code}"
      end
      @next = program.position + @size
    end
    
    def run
      # puts "program is: #{@program.memory}"
      # puts "code is #{@code}"
      case @code
      when 1
        @program.add
      when 2
        @program.multiply
      when 3
        @program.store
      when 4
        @program.output  
      when 5
        @program.jump_if_true
      when 6
        @program.jump_if_false
      when 7
        @program.less_than
      when 8  
        @program.equals
      when 99
        @program.done = true
      end
    end  
    
    def param_1(program)
      param_num(1, program)
    end
    
    def param_2(program)
      param_num(2, program)
    end
    
    private 
    
    def param_num(num, program)
      mode = @param_modes[num-1]
      return program.val_of_address_at_offset(num) if mode == 0
      return program.val_at_offset(num)
    end  
    
    def parse_instruction(code)
      full_code = "%05d" % code
      @code = full_code[3,2].to_i
      @param_modes = full_code[0, 3].split('').map(&:to_i).reverse
    end
  end   
   
  class Program
    attr_accessor :done, :memory, :position, :outputs

    def initialize(intcode, inputs = [])
      @memory = intcode.clone
      @done = false
      @position = 0
      @inputs = [inputs].flatten
    end
  
    def run
      # puts "\n\nPROGRAM IS: #{self.memory}"
      while !done
        do_next_instruction
        jump_to_next
      end  
      self.memory[0]
    end
  
    def do_next_instruction
      # puts "processing opcode at: #{position}: #{self.memory[self.position]}"
      # puts "POSITION IS #{self.position}"
      @current_opcode = Opcode.new(self)
      @current_opcode.run
    end
  
    def add
      self.memory[write_position] = @current_opcode.param_1(self) + @current_opcode.param_2(self)
    end
  
    def multiply
      self.memory[write_position] = @current_opcode.param_1(self) * @current_opcode.param_2(self)
    end  
    
    def store
      input = @inputs.shift
      # puts "input is #{input}"
      # puts "write it to #{write_position}"
      self.memory[write_position] = input
    end
    
    def output
      @outputs ||= []
      @outputs << @current_opcode.param_1(self)
      puts "Output: #{@outputs.last}"
    end
    
    def jump_if_true
      if @current_opcode.param_1(self) != 0
        @current_opcode.next = @current_opcode.param_2(self)
      end  
    end
    
    def jump_if_false
      # puts "Jump to #{@current_opcode.param_2(self)} if #{@current_opcode.param_1(self)} is 0"
      if @current_opcode.param_1(self) == 0
        @current_opcode.next = @current_opcode.param_2(self)
      end  
    end
    
    def less_than
      self.memory[write_position] = @current_opcode.param_1(self) < @current_opcode.param_2(self) ? 1 : 0
    end
    
    def equals
      self.memory[write_position] = @current_opcode.param_1(self) == @current_opcode.param_2(self) ? 1 : 0
    end
    
    def val_of_address_at_offset(num)
      position = val_at_offset(num)
      self.memory[position]
    end
    
    def val_at_offset(num)
      self.memory[self.position + num]
    end
    
    private

    def write_position
      self.memory[self.position + @current_opcode.size - 1]
    end 
    
    def jump_to_next
      self.position = @current_opcode.next
      # puts "New position is #{self.position}"
    end  
           
  end
end