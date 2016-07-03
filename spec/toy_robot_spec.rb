# require "toy_robot"

class ToyRobot
  attr_reader :x, :y, :facing, :commands
  BOARD_LENGTH = 5

  # commands: PLACE, MOVE, LEFF, RIGHT, REPORT
  def execute(commands)
    @commands = commands.split(" ")
    parsing_place_command = false
    @commands.each do |command|
      if command == "PLACE"
        parsing_place_command = true
        next
      end
      if parsing_place_command
        raise "Invalid arguments for place command" unless place_command_args_valid?(command)
        execute_place_command command
        parsing_place_command = false
      end
    end
  end

  def position_valid?(x:, y:)
    (x > 0 && y > 0 && x < BOARD_LENGTH && y < BOARD_LENGTH)
  end

  def place_command_args_valid?(command_args)
    command_args =~ /[0-5]{1},[0-5]{1},(WEST|EAST|NORTH|SOUTH)/
  end

  def execute_place_command(place_args)
    args = place_args.split(",")
    @x = args[0].to_i
    @y = args[1].to_i
    @facing = args[2]
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

  describe "#position_valid?" do
    it "returns false when current position is greater than board length" do
      expect(robot.position_valid?(x: 0, y: 5)).to be false
    end
  end
end

