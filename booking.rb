require "date"

class Booking

  attr_reader :guest, :num_of_guests, :dates
  attr_accessor :room
  # , :check_in, :check_out

  def initialize(options = {})
    @guest = options[:guest]
    @num_of_guests = options[:num_of_guests]
    @room = options[:room] ? options[:room] : nil
    @dates = dates_for_nights(options[:arrival_date], options[:num_of_nights])
    # @check_in = options[check_in]
    # @check_out = options[check_out]
  end

  def arrival_date
    @dates[0]
  end

  def departure_date
    @dates[-1].next
  end

  def num_of_nights
    @dates.length
  end

  def format
    """Guest:\t\t#{@guest.full_name}
Num of Guests:\t#{@num_of_guests}
Room:\t\t#{@room.room_number}
Arrival Date:\t#{arrival_date}
Departure Date:\t#{departure_date}
Num of Nights:\t#{num_of_nights}"""
  end


  private

    def dates_for_nights(arrival_date, num_of_nights)
      (0...num_of_nights).map { |n| arrival_date.next_day(n) }
    end

end