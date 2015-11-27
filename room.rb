class Room

  attr_reader :type, :room_number

  def initialize(type, room_number)
    @type = type
    @room_number = room_number
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

end