DEBUG = true

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
        raise "Something has gone wrong, input is #{@code}"
      end
      @next = program.position + @size
    end
    
    def run
      puts "#{@program.name}: code is #{@code}" if DEBUG
      case @code
      when 1
        add
      when 2
        multiply
      when 3
        store
      when 4
        output  
      when 5
        jump_if_true
      when 6
        jump_if_false
      when 7
        less_than
      when 8  
        equals
      when 99
        @program.done = true
      end
    end  
    
    def add
      @program.memory[@program.write_position] = param_1 + param_2
      puts "ADDING" if DEBUG
    end
  
    def multiply
      @program.memory[@program.write_position] = param_1 * param_2
      puts "MULTIPLY" if DEBUG
    end  
    
    def store
      puts "STORING INPUT" if DEBUG
      input = @program.input
      puts "INPUT TO STORE: #{input}" if DEBUG
      @program.memory[@program.write_position] = input
    end
    
    def output
      puts "OUTPUT #{param_1}" if DEBUG
      @program.outputs << param_1
    end
    
    def jump_if_true
      puts "JUMP IF TRUE" if DEBUG
      if param_1 != 0
        self.next = param_2
      end  
    end
    
    def jump_if_false
      puts "Jump to #{@current_opcode.param_2(self)} if #{@current_opcode.param_1(self)} is 0" if DEBUG
      if param_1 == 0
        self.next = param_2
      end  
    end
    
    def less_than
       puts "LESS THAN" if DEBUG
      @program.memory[@program.write_position] = param_1 < param_2 ? 1 : 0
    end
    
    def equals
      puts "EQUAL" if DEBUG
      @program.memory[@program.write_position] = param_1 == param_2 ? 1 : 0
    end
    
    def param_1
      param_num(1)
    end
    
    def param_2
      param_num(2)
    end
    
    private 
    
    def param_num(num)
      mode = @param_modes[num-1]
      return @program.val_of_address_at_offset(num) if mode == 0
      return @program.val_at_offset(num)
    end  
    
    def parse_instruction(code)
      full_code = "%05d" % code
      @code = full_code[3,2].to_i
      @param_modes = full_code[0, 3].split('').map(&:to_i).reverse
    end
  end   
   
  class Program
    attr_accessor :done, :memory, :position, :outputs, :inputs, :name

    def initialize(intcode, inputs = [], name = 'Computer')
      @memory = intcode.clone
      @done = false
      @position = 0
      @inputs = Queue.new
      [inputs].flatten.each {|input| @inputs << input}
      @outputs = Queue.new
      @name = name
    end
  
    def run
      while !done
        do_next_instruction
        jump_to_next unless done
      end
      puts "#{name} IS DONE"
        # this needs to be here for 7A to work, but needs
        # to be commented out for 7B to work
      outputs&.shift unless outputs.empty?
    end

    def run_async
      while !done
        do_next_instruction
        jump_to_next unless done
      end
      puts "#{name} IS DONE"
    end
  
    def do_next_instruction
      @current_opcode = Opcode.new(self)
      @current_opcode.run
    end
    
    def input
      while @inputs.empty? do
        sleep 0.0001
      end
      @inputs.shift
    end
    
    def val_of_address_at_offset(num)
      position = val_at_offset(num)
      self.memory[position]
    end
    
    def val_at_offset(num)
      self.memory[self.position + num]
    end
    
    def write_position
      self.memory[self.position + @current_opcode.size - 1]
    end 
    
    private
    
    def jump_to_next
      self.position = @current_opcode.next
      puts "\n#{name}: New position is #{self.position}" if DEBUG
    end  
  end
end