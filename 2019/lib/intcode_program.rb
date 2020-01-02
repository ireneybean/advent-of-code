DEBUG = true

module Intcode
  class ParameterMode
    POSITION  = 0
    IMMEDIATE = 1
    RELATIVE  = 2
  end

  class Opcode
    attr_reader :size, :param_modes
    attr_accessor :next

    def initialize(program)
      @program = program
      parse_instruction(program.memory[program.position])
      case @code
      when 1, 2, 7, 8
        @size = 4
      when 3, 4, 9
        @size = 2
      when 5, 6
        @size = 3
      when 99
        @size = 1
      else
        raise "Something has gone wrong, input is #{@code}"
      end
      @next = program.position + @size
    end

    def run
      puts "#{@program.name}: code at #{@program.position} is #{@code}" if DEBUG
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
      when 9
        move_relative_base
      when 99
        @program.done = true
      end
    end

    def add
      @program.memory[@program.write_position] = param_1 + param_2
      puts "ADDING #{param_1} to #{param_2} = #{@program.memory[@program.write_position]}, stored at #{@program.write_position}" if DEBUG
    end

    def multiply
      @program.memory[@program.write_position] = param_1 * param_2
      puts "MULTIPLY #{param_1} and #{param_2} = #{@program.memory[@program.write_position]}, stored at #{@program.write_position}" if DEBUG
    end

    def store
      input = @program.input
      puts "STORING INPUT: #{input} at #{@program.write_position}" if DEBUG
      @program.memory[@program.write_position] = input
    end

    def output
      puts "OUTPUT #{param_1}" if DEBUG
      @program.outputs << param_1
    end

    def jump_if_true
      puts "JUMP IF TRUE (go to #{param_2} if #{param_1} is not 0)" if DEBUG
      if param_1 != 0
        self.next = param_2
      end
    end

    def jump_if_false
      puts "JUMP IF FALSE (go to #{param_2} if #{param_1} is 0)" if DEBUG
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

    def move_relative_base
      puts "MOVE RELATIVE BASE BY #{param_1}" if DEBUG
      @program.relative_base = @program.relative_base + param_1
    end

    def param_1
      param_num(1)
    end

    def param_2
      param_num(2)
    end

    def param_num(num)
      mode = @param_modes[num - 1]
      return @program.val_of_address_at_offset(num) if mode == ParameterMode::POSITION

      return @program.val_of_address_at_offset_relative(num) if mode == ParameterMode::RELATIVE

      @program.val_at_offset(num)
    end

    private

    def parse_instruction(code)
      full_code    = "%05d" % code
      @code        = full_code[3, 2].to_i
      @param_modes = full_code[0, 3].split('').map(&:to_i).reverse
    end
  end

  class Program
    attr_accessor :done, :memory, :position, :outputs, :inputs, :name, :relative_base

    def initialize(intcode, inputs = [], name = 'Computer')
      @memory   = intcode.dup
      @done     = false
      @position = 0
      @inputs   = Queue.new
      [inputs].flatten.each { |input| @inputs << input }
      @outputs = Queue.new
      @name    = name
      @relative_base = 0
    end

    def run
      until done
        do_next_instruction
        jump_to_next unless done
      end
      puts "#{name} IS DONE"

      # this needs to be here for 7A to work, but needs
      # to be commented out for 7B to work
      final_output = []
      final_output << outputs&.shift until outputs.empty?
      final_output.join(',')
    end

    def run_async
      until done
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
      self.memory[val_at_offset(num)]  || 0
    end

    def val_of_address_at_offset_relative(num)
      puts "OFFSET POSITION FOR NUM #{num} is #{val_at_offset(num)}"
      self.memory[val_at_offset(num) + relative_base]  || 0
    end


    def val_at_offset(num)
      self.memory[self.position + num]
    end

    def write_position
      offset = @current_opcode.size - 1
      write_address = val_at_offset(offset)
      mode = @current_opcode.param_modes[offset - 1]
      case mode
      when ParameterMode::POSITION
        write_address
      when ParameterMode::RELATIVE
        write_address + relative_base
      else
        raise 'Write mode is wrong'
      end
    end

    private

    def jump_to_next
      self.position = @current_opcode.next
    end
  end
end