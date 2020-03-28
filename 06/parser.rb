require_relative 'parsed_command'

class Parser
  attr_reader :command_type, :symbol, :dest, :comp, :jump

  def initialize(input_stream)
    @input_stream = input_stream
  end

  def parse
    line_number = 1
    @input_stream.each_line do |line|
      yield ParsedCommand.new(line, line_number)
      line_number += 1
    end
  end

  def rewind
    @input_stream.rewind
  end
end
