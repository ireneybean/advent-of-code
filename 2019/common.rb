module AdventOfCode
  def inputs(day)
    input_array = []
    File.open("inputs/#{day}.txt").each_line {|line| input_array << line }
    input_array
  end
end    

include AdventOfCode