class Room

  attr_reader :type, :room_number

  def initialize(type, room_number)
    @type = type
    @room_number = room_number
  end

end