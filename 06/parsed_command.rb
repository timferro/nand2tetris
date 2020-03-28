class ParsedCommand
  attr_reader :line_number, :type, :symbol, :dest, :comp, :jump

  A_COMMAND = 0
  C_COMMAND = 1
  L_COMMAND = 2
  BLANK = 3

  def initialize(line, line_number)
    @line_number = line_number
    @line = line
    parse
  end

  def parse
    strip
    @type = parse_type
    @symbol = parse_symbol
    @dest = parse_dest
    @comp = parse_comp
    @jump = parse_jump
    @address = parse_address
  end

  def strip
    @line = @line.gsub(/(.*)\/\/.*/, '\1').strip!
  end

  def parse_type
    return L_COMMAND if @line =~ /^\(/
    return A_COMMAND if @line =~ /^@/
    return BLANK if @line.empty?
    C_COMMAND
  end

  def parse_symbol
    return nil unless @type == L_COMMAND
    @line.scan(/^\(([A-Z]*)\)/).first.first
  end

  def parse_dest
    return nil unless @type == C_COMMAND
    return nil unless @line =~ /=/
    @line.split('=').first
  end

  def parse_comp
    return nil unless @type == C_COMMAND
    @line.split(';').first.split('=').last
  end

  def parse_jump
    return nil unless @type == C_COMMAND
    return nil unless @line =~ /;/
    @line.split(';').last
  end

  def parse_address
    return nil unless @type == A_COMMAND
    @line.split('@').last
  end
end
