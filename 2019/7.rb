#!/usr/bin/env ruby

require './lib/common.rb'
require './lib/intcode_program.rb'

INTCODE = AdventOfCode::inputs(7).first.split(',').map(&:to_i).freeze

class Amp
  attr_reader :name

  def initialize(intcode, phase_setting, name = '')
    puts "initializing Amp #{name} with #{phase_setting}" if DEBUG
    @name = name
    @program = Intcode::Program.new(intcode.dup, [phase_setting], "Amp #{name}")
  end

  def run(signals)
    if signals.is_a?(Queue)
      unless @program.inputs.empty?
        puts "MERGING #{name}" if DEBUG
        merged = Queue.new
        until @program.inputs.empty?
          move_me = @program.inputs.pop
          puts "moving #{move_me} to new queue" if DEBUG
          merged << move_me
        end
        merged << signals.pop until signals.empty?
        signals << merged.pop until merged.empty?
      end
      @program.inputs = signals
    elsif signals.is_a?(Numeric)
      @program.inputs << signals
    end
    @program.run
  end

  def run_async(signals)
    if signals.is_a?(Queue)
      unless @program.inputs.empty?
        puts "MERGING #{name}" if DEBUG
        merged = Queue.new
        until @program.inputs.empty?
          move_me = @program.inputs.pop
          puts "moving #{move_me} to new queue" if DEBUG
          merged << move_me
        end
        merged << signals.pop until signals.empty?
        signals << merged.pop until merged.empty?
      end
      @program.inputs = signals
    elsif signals.is_a?(Numeric)
      @program.inputs << signals
    end
    @program.run_async
  end
  
  def done?
    @program.done
  end

  def output
    @program.outputs
  end

  def <<(val)
    @program.inputs << val
  end
end

class AmpArray
  def initialize(intcode, phase_settings)
    @amps = phase_settings.map.with_index{ |phase, index| Amp.new(intcode, phase, index) }
  end
  
  def start
    @amps.inject(0) { |input, amp| amp.run(input) }
  end
end

class LoopedAmpArray < AmpArray
  def start
    threads = []
    @amps.inject(@amps.last.output) do |input, amp|
      threads << Thread.new { amp.run_async(input) }
      amp.output
    end
    @amps.first << 0
    threads.each(&:join)

    answer = @amps.last.output.pop
    puts "ALL THREADS DONE: #{answer}" if DEBUG
    answer
  end
end

def find_max_signal(intcode, phase_array)
  phase_array.permutation.map { |permutation| AmpArray.new(intcode, permutation).start }.max
end

def find_max_signal_with_feedback(intcode, phase_array)
  phase_array.permutation.map { |permutation| LoopedAmpArray.new(intcode, permutation).start }.max
end

PHASES_A = [0,1,2,3,4].freeze
AdventOfCode::test(43210) do
  test_1 = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
  find_max_signal(test_1, PHASES_A)
end

AdventOfCode::test(54321) do
  test_2 = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
  find_max_signal(test_2, PHASES_A)
end

AdventOfCode::test(65210) do
  test_3 = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
  find_max_signal(test_3, PHASES_A)
end

puts "7A: The highest signal that can be sent to the thrusters is: #{find_max_signal(INTCODE, PHASES_A)}" # 117312

PHASES_B = [5,6,7,8,9].freeze

AdventOfCode::test(139629729) do
  test_4 = [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]
  find_max_signal_with_feedback(test_4, PHASES_B)
end

AdventOfCode::test(18216) do
 test_5 = [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,
           54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10]
 find_max_signal_with_feedback(test_5, PHASES_B)
end

puts "7B: The highest signal that can be sent to the thrusters is: #{find_max_signal_with_feedback(INTCODE, PHASES_B)}"
#1336480