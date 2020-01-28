module AdventOfCode
  def inputs(day)
    input_array = []
    File.open("inputs/#{day}.txt").each_line {|line| input_array << line }
    input_array
  end
  
  def test(expected, &block)
    actual = yield
    result = if expected == actual
      "Passed"
    else 
      "Failed: Expected #{expected}, received #{actual}"
    end
    puts result
  end

  def intcode_from_file(day)
    inputs(day).first.split(',').map(&:to_i)
  end

end    

include AdventOfCode