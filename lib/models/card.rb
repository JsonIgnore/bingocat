class Card

  def initialize(spaces, made_from = nil, id = nil)
    @spaces = spaces
    @made_from = made_from
    @id = id
  end

  def self.generate(values = (1..24).to_a , free_space = "Free", made_from = nil)
    spaces = Array.new(25)
    spaces[0,12] = values[0,12]
    spaces[12] = free_space
    spaces[13,12] = values[12,12]

    Card.new(spaces, made_from)
  end

  def get_spaces
    @spaces
  end

  def get_space(row, column)
    @spaces[convert_to_position(row, column)]
  end

  def get_defining_terms
    @made_from
  end

  def get_id
    @id
  end

  private

  def convert_to_position(row, column)
    (row * 5) + column
  end

end