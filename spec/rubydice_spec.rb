RSpec.describe Rubydice do
  it "has a version number" do
    expect(Rubydice::VERSION).not_to be nil
  end

  describe "Rubydice.parse" do
    it "parse count and dietype" do
      dice = Rubydice.parse("3d6")
      options = dice.instance_variable_get(:@options)
      expect(options.count).to eq(3)
      expect(options.dietype).to eq(6)
    end

    it "parses positive static modifier" do
      dice = Rubydice.parse("3d8+3")
      options = dice.instance_variable_get(:@options)
      expect(options.static).to eq(3)
    end

    it "parses negative static modifier" do
      dice = Rubydice.parse("3d8-2")
      options = dice.instance_variable_get(:@options)
      expect(options.static).to eq(-2)
    end

    it "parses regardless of case" do
      dice = Rubydice.parse("3D4-1")
      options = dice.instance_variable_get(:@options)
      expect(options.dietype).to eq(4)
    end
  end

  describe "Rubydice.roll" do
    it "supports calling a static roll method" do
      expect{Rubydice.roll("1d4+1")}.to_not raise_error
    end
  end

  describe "simple rolling" do
    it "rolls the right number of dice" do
      dice = Rubydice.parse("4D6")
      allow(dice).to receive(:one_die) { 1 }
      expect(dice.roll).to eq(4)
    end

    it "adds static addition modifiers" do
      dice = Rubydice.parse("4D6+4")
      allow(dice).to receive(:one_die) { 1 }
      expect(dice.roll).to eq(8)
    end

    it "subtracts static minus modifiers" do
      dice = Rubydice.parse("4D6-2")
      allow(dice).to receive(:one_die) { 1 }
      expect(dice.roll).to eq(2)
    end
  end

  describe "best of dice" do
    it "only uses the number of dice set by best option" do
      dice = Rubydice.parse("4D6", best: 3)
      allow(dice).to receive(:one_die) { 6 }
      expect(dice.roll).to eq(18)
    end

    it "takes the best set from the rolls" do
      dice = Rubydice.parse("4D6", best: 3)
      rolls = [3,4,5,6]
      allow(dice).to receive(:one_die) { rolls.pop }
      expect(dice.roll).to eq(15)
    end
  end

  describe "worst of dice" do
    it "only uses the number of dice set by worst option" do
      dice = Rubydice.parse("4D6", worst: 3)
      allow(dice).to receive(:one_die) { 6 }
      expect(dice.roll).to eq(18)
    end

    it "takes the worst set from the rolls" do
      dice = Rubydice.parse("4D6", worst: 3)
      rolls = [3,4,5,6]
      allow(dice).to receive(:one_die) { rolls.pop }
      expect(dice.roll).to eq(12)
    end
  end

  describe "rerolling dice" do
    it "rerolls a value equal to the reroll value" do
      dice = Rubydice.parse("3D6", reroll: 1)
      rolls = [1,2,3,4]
      allow(dice).to receive(:one_die) { rolls.pop }
      expect(dice.roll).to eq(9)
    end

    it "doesn't reroll if the reroll value is not rolled" do
      dice = Rubydice.parse("3D6", reroll: 1)
      rolls = [3,4,5]
      allow(dice).to receive(:one_die) { rolls.pop }
      expect(dice.roll).to eq(12)
    end

    it "continues to reroll until the value is over the reroll option" do
      dice = Rubydice.parse("3D6", reroll: 1)
      rolls = [3,4,1,1,1,1,5]
      allow(dice).to receive(:one_die) { rolls.pop }
      expect(dice.roll).to eq(12)
    end
  end

  describe "exploding dice" do
    it "accumulates values when they match the explode value" do
      dice = Rubydice.parse("2D10", explode: 10)
      rolls = [4,10,9]
      allow(dice).to receive(:one_die) { rolls.pop }
      expect(dice.roll).to eq(23)
    end

    it "will continue to explode if the explode value recurs" do
      dice = Rubydice.parse("2D10", explode: 10)
      rolls = [4,10,10,10,9]
      allow(dice).to receive(:one_die) { rolls.pop }
      expect(dice.roll).to eq(43)
    end

  end

end
