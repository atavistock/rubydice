RSpec.describe Rubydice::Options do

  describe 'Option#attribute_sanity_check!' do
    it 'ensures required attributes are present' do
      dice = Rubydice.parse("1d4+1")
      options = dice.instance_variable_get(:@options)
      expect(options.count).to eq(1)
      expect(options.dietype).to eq(4)
      expect(options.static).to eq(1)
    end

    it 'always has some value for static (even if its zero)' do
      dice = Rubydice.parse("1d4")
      options = dice.instance_variable_get(:@options)
      expect(options.static).to eq(0)
    end

    it 'ensures dietype is within known list' do
      expect { Rubydice.parse("1d9") }.to raise_error(DiceError)
      expect { Rubydice.parse("1d25") }.to raise_error(DiceError)
      expect { Rubydice.parse("1d20") }.to_not raise_error
    end

    it 'ensures count is greater than 1' do
      expect { Rubydice.parse("0d8") }.to raise_error(DiceError)
    end

    it 'ensures count is not too large (over 100)' do
      expect { Rubydice.parse("101d20") }.to raise_error(DiceError)
    end
  end

  describe 'Option#best_option_sanity_check!' do
    it 'ensures best option is more than one' do
      expect { Rubydice.parse("2d4", best: -1) }.to raise_error(DiceError)
    end

    it 'ensures best option is less than the number of dice' do
      expect { Rubydice.parse("2d4", best: 3) }.to raise_error(DiceError)
    end

    it 'does not raise if within bounds' do
      expect { Rubydice.parse("2d4", best: 1) }.to_not raise_error
    end
  end

  describe 'Option#worst_option_sanity_check!' do
    it 'ensures worst option is more than one' do
      expect { Rubydice.parse("2d4", worst: -1) }.to raise_error(DiceError)
    end

    it 'ensures worst option is less than the number of dice' do
      expect { Rubydice.parse("2d4", worst: 3) }.to raise_error(DiceError)
    end

    it 'doesn not raise if within bounds' do
      expect { Rubydice.parse("2d4", worst: 1) }.to_not raise_error
    end
  end

  describe 'Option#reroll_option_sanity_check!' do
    it 'ensures reroll option is more than one' do
      expect { Rubydice.parse("2d6", reroll: -2) }.to raise_error(DiceError)
    end

    it 'ensures reroll does not exceed die type maximium' do
      expect { Rubydice.parse("2d6", reroll: 7) }.to raise_error(DiceError)
    end

    it 'ensures reroll retains at least two potential values' do
      expect { Rubydice.parse("2d6", reroll: 5) }.to raise_error(DiceError)
      expect { Rubydice.parse("2d6", reroll: 4) }.to_not raise_error
    end

    it 'does not raise if within bounds' do
      expect { Rubydice.parse("2d6", reroll: 1) }.to_not raise_error
    end
  end

  describe 'Option#explode_option_sanity_check!' do
    it 'ensures explode option is greater than 2' do
      expect { Rubydice.parse("2d6", explode: -2) }.to raise_error(DiceError)
      expect { Rubydice.parse("2d6", explode: 1) }.to raise_error(DiceError)
      expect { Rubydice.parse("2d6", explode: 2) }.to_not raise_error
    end
  end

end