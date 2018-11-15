class Rubydice

  class Options

    VALID_DIETYPES = [2,3,4,6,8,10,12,20,32,36,100].freeze

    REQUIRED_ATTRIBUTES = %i{count dietype static}.freeze
    OPTIONAL_ATTRIBUTES = %i{best worst explode reroll}.freeze

    # Methodize known options for better readability
    [*REQUIRED_ATTRIBUTES, *OPTIONAL_ATTRIBUTES].each do |attribute|
      define_method(attribute) { @_options[attribute] }
    end

    def initialize(options)
      options.transform_keys!(&:to_sym)
      options.transform_values!(&:to_i)
      options.delete_if { |k,v| v.nil? || v == 0 }
      options[:static] ||= 0

      @_options = options
      sanity_check!
    end

    # to_s on required attributes generates a string like the a parsed string
    def required_attributes_to_s
      str = "#{self.count}D#{self.dietype}"
      str << "+" if self.static > 0
      str << "#{self.static}" if options.static != 0
      str
    end

    def optional_attributes_to_s
      @_options.slice(OPTIONAL_ATTRIBUTES).to_s
    end

    private

    def sanity_check!
      REQUIRED_ATTRIBUTES.each do |attribute|
        raise DiceError.new("#{attribute} is required") unless @_options[attribute]
      end

      if !VALID_DIETYPES.include?(self.dietype)
        raise DiceError.new('D#{self.dietype} is an invalid die type')
      end

      if self.count < 1 || self.count > 100
        raise DiceError.new('#{self.count} is an unrealistic number of dice')
      end

      if self.best && (self.best >= self.count || self.best < 1)
        raise DiceError.new("Best #{self.best} of #{self.count} doesn't make sense")
      end

      if self.worst && (self.worst >= self.count || self.worst < 1)
        raise DiceError.new("Worst #{self.worst} of #{self.count} doesn't make sense")
      end

      if self.reroll && self.reroll >= self.dietype - 1
        raise DiceError.new("Reroll #{self.reroll}s on D#{self.dietype} doesn't work")
      end

      if self.reroll && self.reroll >= self.dietype - 1
        raise DiceError.new("Reroll #{self.reroll}s is larger than D#{self.dietype}")
      end

      if self.explode && self.explode <= 1
        raise DiceError.new("Explode must be greater than 1")
      end
    end

  end

end