class Booking

  attr_reader :guest, :num_of_guests
  attr_accessor :room
  # , :check_in, :check_out

  def initialize(options = {})
    @guest = options[:guest]
    @num_of_guests = options[:num_of_guests]
    @room = options[:room] ? options[:room] : nil
    # @check_in = options[check_in]
    # @check_out = options[check_out]
  end

  def format
    "Guest:\t#{guest.full_name}\nNum of Guests:\t#{num_of_guests}\nRoom:\t#{room.room_number}"
  end

end