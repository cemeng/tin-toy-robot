require "toy-robot"

RSpec.describe ToyRobot do
  let (:robot) { ToyRobot.new }

  describe "#execute" do
    it "executes the commands correctly" do
      result = robot.execute("PLACE 0,0,NORTH MOVE REPORT")
      expect(result).to eq "0,1,NORTH"
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
        robot.execute("PLACE 0,0,WEST MOVE") # invalid
        robot.execute("RIGHT MOVE") # valid, moves north one step
        expect(robot.y).to eq 1
      end
    end
  end

  describe "#position_valid?" do
    it "returns false when current position is greater than board length" do
      expect(robot.position_valid?(x: 0, y: 5)).to be false
    end
  end
end

