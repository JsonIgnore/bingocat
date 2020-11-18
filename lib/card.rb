class Card
  @spaces

  def initialize(values = (1..24).to_a , free_space = "Free")
    @spaces = Array.new(25)
    @spaces[0,12] = values[0,12]
    @spaces[12] = free_space
    @spaces[13,12] = values[12,12]
  end

  def get_space(row, column)
    return @spaces[convert_to_position(row, column)]
  end

  private

  def convert_to_position(row, column)
    return (row * 5) + column
  end

end