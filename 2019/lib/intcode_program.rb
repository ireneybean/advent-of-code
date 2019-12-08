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