require_relative "card"

class TermSet

  @id = nil
  @name = nil
  @terms
  @free_space

  def initialize(terms = Array.new(24), free_space = "Free", name=nil, id=nil)
    @id = id
    @name = name
    @terms = terms
    @free_space = free_space
  end

  def self.make_numeric_terms(min=1, max=75)
    numbers = Array(min..max)
    return TermSet.new(numbers, "Free", "Common Bingo")
  end

  def get_name()
    return @name
  end

  def get_terms()
    return @terms
  end

  def get_free_space()
    return @free_space
  end

  def generate_random_card()
    unused_terms = @terms.dup
    selection = []
    rng = Random.new

    24.times do
      selection << unused_terms.delete_at(rng.rand(unused_terms.size))
    end

    return Card.new(selection, @free_space)
  end

end