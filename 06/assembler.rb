require 'slop'

require_relative 'code'
require_relative 'parsed_command'
require_relative 'parser'

class Assembler

  attr_accessor :opts

  def initialize
    parse_opts
    @symbol_table = {
      "SP" => 0,
      "LCL" => 1,
      "ARG" => 2,
      "THIS" => 3,
      "THAT" => 4,
      "R0" => 0,
      "R1" => 1,
      "R2" => 2,
      "R3" => 3,
      "R4" => 4,
      "R5" => 5,
      "R6" => 6,
      "R7" => 7,
      "R8" => 8,
      "R9" => 9,
      "R10" => 10,
      "R11" => 11,
      "R12" => 12,
      "R13" => 13,
      "R14" => 14,
      "R15" => 15,
      "SCREEN" => 16384,
      "KBD" => 24576
    }
    @mem_pointer = 16
  end

  def parse_opts
    @opts = Slop.parse do |o|
      o.string '-i', '--sourcefile', 'relative path to source file'
      o.string '-o', '--outputfile', 'relative path to output file'
      o.bool '-d', '--debug', 'enable debug messages'
    end
    puts opts.to_hash if opts.debug?
  end

  def execute
    @input_file = File.open(opts[:sourcefile])
    @output_file = File.open(opts[:outputfile], 'w')

    parse_symbols
    @input_file.rewind
    assemble

    command_address = 0
  ensure
    @input_file&.close
    @output_file&.close
  end

  def parse_symbols
    program_counter = 0
    Parser.new(@input_file).parse do |parsed_command|
      next if parsed_command.type == ParsedCommand::BLANK

      if parsed_command.type == ParsedCommand::L_COMMAND
        puts "setting #{parsed_command.symbol} to #{program_counter}" if opts[:debug]
        @symbol_table[parsed_command.symbol] = program_counter
      else
        program_counter += 1
      end

    end
  end

  def assemble
    Parser.new(@input_file).parse do |parsed_command|
      case parsed_command.type
      when ParsedCommand::A_COMMAND
        address_command(parsed_command)
      when ParsedCommand::C_COMMAND
        comp_command(parsed_command)
      else
        next
      end
    end
  end

  def address_command(parsed_command)
    address = parsed_command.address
    unless (Integer(address) rescue false)
      unless @symbol_table.has_key? address
        @symbol_table[address] = @mem_pointer
        @mem_pointer += 1
      end
      puts "looking up #{address} in #{@symbol_table}" if opts[:debug]
      address = @symbol_table[address]
    end
    address = Integer(address)
    bin = address.to_s(2).rjust(16, '0')
    @output_file.puts(bin)
  end

  def comp_command(parsed_command)
    prefix = '111'
    comp = Code.comp(parsed_command.comp)
    dest = Code.dest(parsed_command.dest)
    jump = Code.jump(parsed_command.jump)
    @output_file.puts(prefix + comp + dest + jump)
  end
end

Assembler.new.execute
