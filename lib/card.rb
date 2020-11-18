
class Card
  @spaces

  def initialize
    @spaces = []
    (1..25).each do |n|
      @spaces << "Space #{n}"
    end
  end

  def get_space(number)
    return @spaces[number]
  end

end