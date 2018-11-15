require "rubydice/version"
require "rubydice/options"

class Rubydice

  EXPLODE_LIMIT = 20

  DICE_PATTERN = /
    (?<count>[0-9]+)D(?<dietype>[0-9]+)
    (?<static>[+-][0-9]+)?
  /ix

  def initialize(options = {})
    @options = Options.new(options)
  end

  def to_s
    [
      @options.required_attributes_to_s,
      @options.optional_attributes_to_s
    ].join(' ')
  end

  def roll
    rolls = @options.count.times.map { one_die }
    rolls = best!(rolls) if @options.best
    rolls = worst!(rolls) if @options.worst
    rolls = reroll!(rolls) if @options.reroll
    rolls = explode!(rolls) if @options.explode
    total = rolls.sum
    total += @options.static if @options.static
    total
  end

  def self.parse(str, options = {})
    str.delete!(' \n\r')
    dice_config = str.match(DICE_PATTERN).named_captures
    options.merge!(dice_config)
    Rubydice.new(options)
  end

  def self.roll(str, options = {})
    parse(str, options).roll
  end

  private

  def one_die
    rand(@options.dietype) + 1
  end

  def best!(rolls)
    rolls.sort.reverse.take(@options.best)
  end

  def worst!(rolls)
    rolls.sort.take(@options.worst)
  end

  def explode!(rolls)
    explode_limit = EXPLODE_LIMIT
    rolls.map do |roll|
      accum = [roll]
      while roll >= @options.explode && explode_limit > 0
        roll = one_die
        accum << roll
        explode_limit -= 1
      end
      accum
    end.flatten
  end

  def reroll!(rolls)
    rolls.map do |roll|
      while roll <= @options.reroll
        roll = one_die
      end
      roll
    end
  end

end
