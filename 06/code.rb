class Code
  COMP_LOOKUP = {
    '0' => '101010',
    '1' => '111111',
    '-1' => '111010',
    'D' => '001100',
    'A' => '110000',
    '!D' => '001101',
    '!A' => '110001',
    '-D' => '001111',
    '-A' => '110011',
    'D+1' => '011111',
    'A+1' => '110111',
    'D-1' => '001110',
    'A-1' => '110010',
    'D+A' => '000010',
    'D-A' => '010011',
    'A-D' => '000111',
    'D&A' => '000000',
    'D|A' => '010101',
    'M' => '110000',
    '!M' => '110001',
    '-M' => '110011',
    'M+1' => '110111',
    'M-1' => '110010',
    'D+M' => '000010',
    'D-M' => '010011',
    'M-D' => '000111',
    'D&M' => '000000',
    'D|M' => '010101'
  }.freeze

  JUMP_LOOKUP = {
    'JGT' => '001',
    'JEQ' => '010',
    'JGE' => '011',
    'JLT' => '100',
    'JNE' => '101',
    'JLE' => '110',
    'JMP' => '111'
  }.freeze

  class << self
    def comp(comp_string)
      mem = comp_string =~ /M/ ? '1' : '0'
      comp = COMP_LOOKUP[comp_string]
      mem + comp
    end

    def dest(dest_string)
      return '000' if dest_string.nil?
      a = dest_string =~ /A/ ? '1' : '0'
      d = dest_string =~ /D/ ? '1' : '0'
      m = dest_string =~ /M/ ? '1' : '0'
      a + d + m
    end

    def jump(jump_string)
      return '000' if jump_string.nil?
      JUMP_LOOKUP[jump_string]
    end
  end
end
