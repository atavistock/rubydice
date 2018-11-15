# Rubydice

Rubydice is a simple and flexible dice implementation to simulate tabletop dice.

## Installation

In most cases its more aestetically pleasing to call `Dice` rather than
`Rubydice`, and simply adding `require: 'dice'` to your Gemfile will make
this happen.

```ruby
gem 'rubydice', require: 'dice'
```

If you already have a `Dice` object you can simply leave out `require: 'dice'` and call methods on `Rubydice` instead.

## Usage

Rubydice will accept, parse, and roll for any standard string indicating quanity, die, and modifier.  Die type is limited to standard RPG dice variants 2, 3, 4, 6, 8, 10, 12, 20, 32, 36, and 100.

In the simplest case simply call the `Dice.roll` with:
```ruby
 Dice.roll('3d6+1')
```

If you can parse and setup any dice confirguation for repeated rolls using the same configuration like:
```ruby
stat_dice = Dice.parse('1D20')
stat1 = stat_dice.roll
stat2 = stat_dice.roll
```

### Options ####

A number of options are supported to allow common use cases supported by different game systems.

__best__

Take the best _n_ dice from the dice rolled
```ruby
Dice.roll('4d6', best: 3)
```

__worst__

Take the worst _n_ dice from the dice rolled
```ruby
Dice.roll('4d6', worst: 3)
```

__reroll__

Reroll any dice with a value of 1
```ruby
Dice.roll('1d20', reroll: 1)
```

__explode__

Any dice with this value get an accumulating reroll
```ruby
Dice.roll('4d10', explode: 10)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/atavistock/rubydice. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
