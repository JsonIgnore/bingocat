class Card
  @spaces
  @made_from

  def initialize(values = (1..24).to_a , free_space = "Free", made_from = nil)
    @spaces = Array.new(25)
    @spaces[0,12] = values[0,12]
    @spaces[12] = free_space
    @spaces[13,12] = values[12,12]
    @made_from = made_from
  end

  def get_spaces
    return @spaces
  end

  def get_space(row, column)
    return @spaces[convert_to_position(row, column)]
  end

  def get_defining_terms
    return @made_from
  end

  private

  def convert_to_position(row, column)
    return (row * 5) + column
  end

end