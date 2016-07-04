require "toy_robot"

RSpec.describe ToyRobot do
  describe "robot starting at 0,0 facing NORTH" do
    let(:robot) do
      robot = ToyRobot.new
      robot.execute("PLACE 0,0,NORTH")
      robot
    end

    it "rotates left reports 0,0,WEST" do
      expect(robot.execute("PLACE 0,0,NORTH LEFT REPORT")).to eq "0,0,WEST"
    end

    it "move twice returns 0,2,NORTH" do
      expect(robot.execute("MOVE MOVE REPORT")).to eq "0,2,NORTH"
    end

    it "move twice, turns right, move once returns 1,2,EAST" do
      expect(robot.execute("MOVE MOVE RIGHT MOVE REPORT")).to eq "1,2,EAST"
    end
  end

  describe "robot placed at 1,2 facing EAST" do
    let(:robot) do
      robot = ToyRobot.new
      robot.execute("PLACE 1,2,EAST")
      robot
    end

    it "move twice, turns left, move once returns 3,3,NORTH" do
      expect(robot.execute("MOVE MOVE LEFT MOVE REPORT")).to eq "3,3,NORTH"
    end
  end
end

