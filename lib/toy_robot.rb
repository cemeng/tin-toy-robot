class ToyRobot
  attr_reader :x, :y, :facing
  BOARD_LENGTH = 5
  DIRECTIONS = %w(NORTH EAST SOUTH WEST).freeze

  def execute(commands)
    parsing_place_command = false

    commands.split(" ").each do |command|
      if parsing_place_command
        execute_place command
        parsing_place_command = false
      end

      case command
      when "PLACE"
        parsing_place_command = true
        next
      when "MOVE"
        execute_move
      when "LEFT", "RIGHT"
        execute_rotate command
      when "REPORT"
        return execute_report
      end
    end
    nil # by default returns nil, unless there is report command
  end

  private

  def position_valid?(x:, y:)
    (x >= 0 && y >= 0 && x < BOARD_LENGTH && y < BOARD_LENGTH)
  end

  def place_command_args_valid?(command_args)
    command_args =~ /[0-5]{1},[0-5]{1},(WEST|EAST|NORTH|SOUTH)/
  end

  def execute_place(place_args)
    raise "Invalid arguments for place command" unless place_command_args_valid?(place_args)
    args = place_args.split(",")
    @x = args[0].to_i
    @y = args[1].to_i
    @facing = args[2]
  end

  def execute_rotate(direction)
    return unless robot_placed?
    @facing = case direction
              when "LEFT"
                DIRECTIONS[DIRECTIONS.find_index(@facing) - 1]
              when "RIGHT"
                DIRECTIONS[DIRECTIONS.find_index(@facing) - 3]
              end
  end

  def execute_move
    return unless robot_placed?
    x_before = @x
    y_before = @y
    case @facing
    when "NORTH" then @y += 1
    when "SOUTH" then @y -= 1
    when "EAST" then @x += 1
    when "WEST" then @x -= 1
    end
    unless position_valid?(x: @x, y: @y)
      @x = x_before
      @y = y_before
    end
  end

  def execute_report
    return unless robot_placed?
    "#{@x},#{@y},#{@facing}"
  end

  def robot_placed?
    @x && @y && @facing
  end
end
