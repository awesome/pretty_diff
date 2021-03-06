module PrettyDiff
  class Chunk
    attr_reader :diff, :meta_info, :lines, :contents

    def initialize(diff, meta_info, contents)
      @diff = diff
      @meta_info = meta_info
      @contents = contents
      @lines = find_lines
    end

    def line_numbers
      @_line_numbers ||= LineNumbers.new(diff, meta_info)
    end

  private

    def find_lines
      [].tap do |lines|
        contents.split(/\r?\n|\r/).each do |line_str|
          line = Line.new(self, line_str)
          next if line.ignored?
          lines << line
          line_numbers.act_on_line(line)
          line.left_number = line_numbers.left_column.last
          line.right_number = line_numbers.right_column.last
        end
      end
    end

  end
end
