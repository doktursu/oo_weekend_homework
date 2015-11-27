class Guest

  attr_reader :title, :forename, :surname, :bookings

  def initialize(title, forename, surname)
    @title = title
    @forename = forename
    @surname = surname
    @bookings = {}
  end

  def full_name
    "#{title} #{forename} #{surname}"
  end

  def check_in(hotel)
  end

  def check_out(hotel)
  end

  def add_booking(booking)
    @bookings[booking.room.room_number] = booking
  end

end