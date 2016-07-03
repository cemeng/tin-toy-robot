require "toy-robot"

RSpec.describe ToyRobot do
  let (:robot) { ToyRobot.new }

  describe "#execute" do
    it "executes the string of commands correctly" do
      result = robot.execute("PLACE 0,0,NORTH MOVE REPORT")
      expect(result).to eq "0,1,NORTH"
      expect(robot.execute("PLACE 0,0,NORTH LEFT REPORT")).to eq "0,0,WEST"
      expect(robot.execute("PLACE 1,2,EAST MOVE MOVE LEFT MOVE REPORT")).to eq "3,3,NORTH"
    end

    it "ignores commands before a place command" do
      robot.execute("MOVE LEFT RIGHT PLACE 0,0,NORTH")
      expect(robot.execute("REPORT")).to eq "0,0,NORTH"
    end
  end

  describe "PLACE command" do
    it "places the robot correctly" do
      robot.execute("PLACE 0,0,WEST")
      expect(robot.x).to eq 0
      expect(robot.y).to eq 0
      expect(robot.facing).to eq "WEST"
    end
  end

  describe "LEFT / RIGHT command" do
    it "rotating left 4 times returns the robot back to its initial facing direction" do
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

    it "rotating right 4 times returns the robot back to its initial facing direction" do
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

  describe "MOVE command" do
    it "moves robot north 1 place when robot faces NORTH" do
      robot.execute("PLACE 0,0,NORTH")
      robot.execute("MOVE")
      expect(robot.y).to eq 1
    end

    describe "to an invalid position" do
      it "should not move the robot when the movement results in robot going out of bound" do
        robot.execute("PLACE 0,0,WEST")
        robot.execute("MOVE")
        expect(robot.x).to eq 0
      end

      it "allos subsequent valid movements" do
        robot.execute("PLACE 0,0,WEST MOVE") # invalid
        robot.execute("RIGHT MOVE") # valid, moves north one step
        expect(robot.y).to eq 1
      end
    end
  end
end
