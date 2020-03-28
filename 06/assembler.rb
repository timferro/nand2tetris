require 'slop'

require_relative 'code'
require_relative 'parsed_command'
require_relative 'parser'
require_relative 'parser_error'

class Assembler

  attr_accessor :opts

  def initialize
    parse_opts
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

    command_address = 0
    Parser.new(@input_file).parse do |parsed_command|
      case parsed_command.type
      when ParsedCommand::A_COMMAND
        address_command(parsed_command)
      when ParsedCommand::C_COMMAND
        comp_command(parsed_command)
      when ParsedCommand::L_COMMAND
        next
      else
        next
      end
    end
  ensure
    @input_file&.close
    @output_file&.close
  end

  def address_command(parsed_command)
    int = parsed_command.parse_address.to_i
    bin = int.to_s(2).rjust(16, '0')
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
