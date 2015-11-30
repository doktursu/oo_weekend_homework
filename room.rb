class Room

  attr_reader :type, :room_number, :rate

  def initialize(type, room_number)
    @type = type
    @room_number = room_number
    @rate = set_rate()
  end

  def format
    "#{@room_number} - #{type_to_string}"
  end

  def type_to_string
    case @type
    when 1
      "Single"
    when 2
      "Double"
    end
  end

  def set_rate
    case @type
    when 1
      40.00
    when 2
      60.00
    end
  end

end