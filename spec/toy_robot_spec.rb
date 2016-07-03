# require "toy_robot"

class ToyRobot
  attr_reader :x, :y, :facing, :commands
  BOARD_LENGTH = 5

  # commands: PLACE, MOVE, LEFF, RIGHT, REPORT
  def execute(commands)
    @commands = commands.split(" ")
    parsing_place_command = false
    @commands.each do |command|
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
      end
    end
  end

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

  DIRECTIONS = %w(NORTH EAST SOUTH WEST).freeze

  def execute_rotate(direction)
    @facing = case direction
              when "LEFT"
                DIRECTIONS[DIRECTIONS.find_index(@facing) - 1]
              when "RIGHT"
                DIRECTIONS[DIRECTIONS.find_index(@facing) - 3]
              end
  end

  def execute_move
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
end

RSpec.describe ToyRobot do
  let (:robot) { ToyRobot.new }

  describe "#execute" do
    it "should parse commands correctly" do
      robot.execute("PLACE 0,0,WEST MOVE LEFT RIGHT REPORT")
      expect(robot.commands.size).to eq 6
    end
  end

  describe "place command" do
    it "places the robot correctly" do
      robot.execute("PLACE 0,0,WEST")
      expect(robot.x).to eq 0
      expect(robot.y).to eq 0
      expect(robot.facing).to eq "WEST"
    end
  end

  describe "LEFT / RIGHT command" do
    it "rotates robot left 4 times return the robot back to its initial facing direction" do
      robot.execute("PLACE 0,0,NORTH")
      robot.execute("LEFT")
      expect(robot.facing).to eq "WEST"
      robot.execute("LEFT")
      expect(robot.facing).to eq "SOUTH"
      robot.execute("LEFT")
      expect(robot.facing).to eq "EAST"
      robot.execute("LEFT")
      expect(robot.facing).to eq "NORTH"
    end

    it "rotates robot right 4 times return the robot back to its initial facing direction" do
      robot.execute("PLACE 0,0,NORTH")
      robot.execute("RIGHT")
      expect(robot.facing).to eq "EAST"
      robot.execute("RIGHT")
      expect(robot.facing).to eq "SOUTH"
      robot.execute("RIGHT")
      expect(robot.facing).to eq "WEST"
      robot.execute("RIGHT")
      expect(robot.facing).to eq "NORTH"
    end
  end

  describe "move command" do
    it "moves robot" do
      robot.execute("PLACE 0,0,NORTH")
      robot.execute("MOVE")
      expect(robot.y).to eq 1
    end

    describe "invalid move" do
      it "should not move the robot when the movement results in robot going out of bound" do
        robot.execute("PLACE 0,0,WEST")
        robot.execute("MOVE")
        expect(robot.x).to eq 0
      end

      it "allos subsequent valid movements after an invalid one" do
      end
    end
  end

  describe "#position_valid?" do
    it "returns false when current position is greater than board length" do
      expect(robot.position_valid?(x: 0, y: 5)).to be false
    end
  end
end

