class Card
  @spaces

  def initialize
    @spaces = Array.new(5)
    (0..4).each do |row|
      @spaces[row] = Array.new(5)
    end
  end

  def get_space(row, column)
    return @spaces[row][column]
  end

  def set_space(row, column, value)
    @spaces[row][column] = value
  end


  def self.make_random_numeric_card(min=1, max=75)
    value_range = Array(min..max)
    rng = Random.new

    card = Card.new

    (0..4).each do |row|
      (0..4).each do |column|
        value = value_range.delete_at(rng.rand(value_range.size))
        card.set_space(row, column, value)
      end
    end

    return card
  end

end